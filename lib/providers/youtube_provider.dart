import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart' show debugPrint;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:zyron/models/youtube_channel_model.dart';

part 'youtube_provider.g.dart';

@Riverpod(keepAlive: true)
class YouTubeList extends _$YouTubeList {
  late final YoutubeHttpClient _ytHttpClient;
  late final ChannelClient _channelClient;
  late final SearchClient _searchClient;

  @override
  List<YouTubeChannelModel> build() {
    _ytHttpClient = YoutubeHttpClient();
    _channelClient = ChannelClient(_ytHttpClient);
    _searchClient = SearchClient(_ytHttpClient);
    return [];
  }

  Future<List<YouTubeChannelModel>> search({required String query}) async {
    final SearchList results =
        await _searchClient.searchContent(query, filter: TypeFilters.channel);
    List<YouTubeChannelModel> channels = [];
    for (final SearchResult channel in results) {
      if (channel is SearchChannel) {
        final Channel c = await _channelClient.get(channel.id.value);
        channels.add(YouTubeChannelModel(
          id: c.id.value,
          name: c.title,
          url: c.url,
          logo: c.logoUrl,
          subscribers: c.subscribersCount ?? -1,
        ));
      }
    }
    return channels;
  }

  Future<void> addChannel(YouTubeChannelModel channel) async {
    if (state.any((c) => c.id == channel.id)) {
      debugPrint('Channel already exists');
      return;
    }
    state = [...state, channel];
    debugPrint('Channel added');
    await saveChannels();
  }

  Future<void> removeChannel(YouTubeChannelModel channel) async {
    if (!state.any((c) => c.id == channel.id)) {
      debugPrint('Channel does not exist');
      return;
    }
    state = state.where((c) => c.id != channel.id).toList();
    debugPrint('Channel removed');
    await saveChannels();
  }

  Future<void> reorderChannel(int oldIndex, int newIndex) async {
    if (oldIndex == newIndex) {
      debugPrint('Same index');
      return;
    }
    final channels = state;
    final channel = channels.removeAt(oldIndex);
    channels.insert(newIndex, channel);
    state = channels;
    debugPrint('Channel reordered');
    await saveChannels();
  }

  Future<void> refreshChannel(YouTubeChannelModel channel) async {
    final Channel c = await _channelClient.get(channel.id);
    final updatedChannel = YouTubeChannelModel(
      id: c.id.value,
      name: c.title,
      url: c.url,
      logo: c.logoUrl,
      subscribers: c.subscribersCount ?? -1,
    );
    final channels = state;
    final index = channels.indexWhere((c) => c.id == channel.id);
    channels[index] = updatedChannel;
    state = channels;
    debugPrint('Channel refreshed');
    await saveChannels();
  }

  String encodeChannels() {
    return jsonEncode(state.map((c) => c.toJson()).toList());
  }

  void decodeChannels(String json) {
    final List<dynamic> decodedJson = jsonDecode(json);
    state = decodedJson.map((c) => YouTubeChannelModel.fromJson(c)).toList();
    debugPrint('${state.length} Channel(s) loaded');
  }

  Future<void> saveChannels() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('zyron_channels', encodeChannels());
    debugPrint('${state.length} Channel(s) saved');
  }

  Future<void> loadChannels() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? json = prefs.getString('zyron_channels');

    if (json == null) {
      return;
    }

    decodeChannels(json);
  }

  Future<bool> exportChannels() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory == null) {
      return false;
    }

    try {
      File file = File('$selectedDirectory/zyron_channels.json');
      String encodedJson = encodeChannels();
      await file.writeAsString(encodedJson);
      debugPrint('Channels exported');
      return true;
    } catch (e) {
      debugPrint('Save Channels Error: $e');
      return false;
    }
  }

  Future<bool> restoreChannels() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result == null || result.files.isEmpty) {
      return false;
    }

    try {
      String selectedFile = result.files.single.path!;
      File file = File(selectedFile);
      String json = await file.readAsString();

      decodeChannels(json);
      return true;
    } catch (e) {
      debugPrint('Load Channels Error: $e');
      return false;
    }
  }
}

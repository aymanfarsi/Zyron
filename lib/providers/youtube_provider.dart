import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart' show debugPrint;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:zyron/models/youtube_channel_model.dart';

part 'youtube_provider.g.dart';

@riverpod
class YouTubeList extends _$YouTubeList {
  @override
  List<YouTubeChannelModel> build() {
    return [];
  }

  Future<List<YouTubeChannelModel>> search({required String query}) async {
    final YoutubeHttpClient ytClient = YoutubeHttpClient();
    final SearchClient searchClient = SearchClient(ytClient);
    final SearchList results = await searchClient.searchContent(
      query,
      filter: TypeFilters.channel,
    );
    List<YouTubeChannelModel> channels = [];
    for (final SearchResult channel in results) {
      if (channel is SearchChannel) {
        final YouTubeChannelModel ytChannel = YouTubeChannelModel(
          id: channel.id.value,
          name: channel.name,
          url: 'https://www.youtube.com/channel/${channel.id.value}',
          logo: '',
        );
        channels.add(ytChannel);
      }
    }
    return channels;
  }

  void addChannel(YouTubeChannelModel channel) {
    state = [...state, channel];
  }

  void removeChannel(YouTubeChannelModel channel) {
    state = state.where((c) => c.id != channel.id).toList();
  }

  void reorderChannel(int oldIndex, int newIndex) {
    final channels = state;
    final channel = channels.removeAt(oldIndex);
    channels.insert(newIndex, channel);
    state = channels;
  }

  String encodeChannels() {
    return jsonEncode(state.map((c) => c.toJson()).toList());
  }

  void decodeChannels(String json) {
    final List<dynamic> decodedJson = jsonDecode(json);
    state = decodedJson.map((c) => YouTubeChannelModel.fromJson(c)).toList();
  }

  Future<void> saveChannels() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('zyron_channels', encodeChannels());
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

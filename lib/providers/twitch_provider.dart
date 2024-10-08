import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart' show debugPrint;
import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zyron/models/twitch_streamer_model.dart';

part 'twitch_provider.g.dart';

@Riverpod(keepAlive: true)
class TwitchList extends _$TwitchList {
  @override
  List<TwitchStreamerModel> build() {
    return [];
  }

  Future<TwitchStreamerModel?> fetchStreamer({required String username}) async {
    try {
      final response = await http.get(
        Uri.parse('https://www.twitch.tv/$username'),
      );
      if (response.statusCode != 200) {
        return null;
      }
      final body = response.body;
      final document = Document.html(body);
      final scriptTag =
          document.querySelectorAll('script[type="application/ld+json"]');
      bool isLive = false;
      String profileImageUrl = '';
      String description = '';
      String displayName = username;
      try {
        final script = scriptTag.first.text;
        final json = jsonDecode(script);
        final dict = json['@graph'].first;
        try {
          isLive = dict['publication']['isLiveBroadcast'] ?? false;
        } catch (e) {
          debugPrint('Error: $e');
        }
        try {
          profileImageUrl = dict['thumbnailUrl'].last ?? '';
        } catch (e) {
          debugPrint('Error: $e');
        }
        try {
          description =
              const Utf8Decoder().convert(dict['description'].codeUnits);
        } catch (e) {
          debugPrint('Error: $e');
        }
        try {
          displayName = dict['name'].split(' ').first ?? username;
        } catch (e) {
          debugPrint('Error: $e');
        }
      } catch (e) {
        debugPrint('Error: $e');
      }
      return TwitchStreamerModel(
        username: username,
        displayName: displayName,
        description: description,
        profileImageUrl: profileImageUrl,
        isLive: isLive,
        url: 'https://www.twitch.tv/$username',
      );
    } catch (e) {
      final kickUsername = username.split('/').last;
      final kickUrl =
          'https://kick.com/api/v2/channels/$kickUsername/livestream';
      final response = await http.get(Uri.parse(kickUrl));
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch streamer');
      }

      final data = jsonDecode(response.body)['data'];
      if (data == null) {
        return TwitchStreamerModel(
          username: kickUsername,
          displayName: kickUsername,
          description: 'No data',
          profileImageUrl: '',
          isLive: false,
          url: null,
        );
      }

      final sessionTitle = data['session_title'];
      final playbackUrl = data['playback_url'];
      final thumbnailSrc = data['thumbnail']['src'];

      return TwitchStreamerModel(
        username: username.split('/').last,
        displayName: kickUsername,
        description: sessionTitle,
        profileImageUrl: thumbnailSrc,
        isLive: playbackUrl != null && playbackUrl.isNotEmpty,
        url: playbackUrl,
      );
    }
  }

  Future<void> refreshStreamers() async {
    final List<TwitchStreamerModel> streamers = state;
    final List<Future<TwitchStreamerModel?>> futures = streamers
        .map((streamer) => fetchStreamer(username: streamer.username))
        .toList();
    final List<TwitchStreamerModel?> updatedStreamers =
        await Future.wait(futures);
    state = updatedStreamers.whereType<TwitchStreamerModel>().toList();
    debugPrint('Streamers refreshed');
    await saveStreamers();
  }

  Future<void> addStreamer(TwitchStreamerModel streamer) async {
    if (state.any((s) => s.username == streamer.username)) {
      debugPrint('Streamer already exists');
      return;
    }
    state = [...state, streamer];

    debugPrint('Streamer added');
    await saveStreamers();
  }

  Future<void> removeStreamer(TwitchStreamerModel streamer) async {
    if (!state.any((s) => s.username == streamer.username)) {
      debugPrint('Streamer does not exist');
      return;
    }
    state = state.where((s) => s.username != streamer.username).toList();

    debugPrint('Streamer removed');
    await saveStreamers();
  }

  Future<void> reorderStreamer({
    required int oldIndex,
    required int newIndex,
  }) async {
    if (oldIndex == newIndex) {
      debugPrint('Same index');
      return;
    }
    final streamers = state;
    final streamer = streamers.removeAt(oldIndex);
    streamers.insert(newIndex, streamer);
    state = streamers;
    //
    debugPrint('Streamer reordered');
    await saveStreamers();
  }

  Future<void> refreshStreamer(TwitchStreamerModel streamer) async {
    final c = await fetchStreamer(username: streamer.username);
    final updatedStreamer = c ?? streamer;
    final index = state.indexWhere((s) => s.username == streamer.username);
    state[index] = updatedStreamer;

    debugPrint('Streamer refreshed');
    await saveStreamers();
  }

  String encodeStreamers() {
    return jsonEncode(state.map((c) => c.toJson()).toList());
  }

  void decodeStreamers(String json) {
    final List<dynamic> decodedJson = jsonDecode(json);
    state = decodedJson.map((c) => TwitchStreamerModel.fromJson(c)).toList();

    debugPrint('${state.length} Streamer(s) loaded');
  }

  Future<void> saveStreamers() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('zyron_streamers', encodeStreamers());

    debugPrint('${state.length} Streamer(s) saved');
  }

  Future<void> loadStreamers() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? json = prefs.getString('zyron_streamers');

    if (json == null) {
      return;
    }

    decodeStreamers(json);
  }

  Future<bool> exportStreamers() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory == null) {
      return false;
    }

    try {
      File file = File('$selectedDirectory/zyron_streamers.json');
      String encodedJson = encodeStreamers();
      await file.writeAsString(encodedJson);

      debugPrint('Streamers exported');
      return true;
    } catch (e) {
      debugPrint('Save Streamers Error: $e');
      return false;
    }
  }

  Future<bool> restoreStreamers() async {
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

      decodeStreamers(json);
      return true;
    } catch (e) {
      debugPrint('Load Streamers Error: $e');
      return false;
    }
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart' show debugPrint;
import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zyron/models/twitch_streamer_model.dart';
import 'package:zyron/src/rust/api/simple.dart';

part 'twitch_provider.g.dart';

@Riverpod(keepAlive: true)
class TwitchList extends _$TwitchList {
  @override
  List<TwitchStreamerModel> build() {
    return [];
  }

  Future<TwitchStreamerModel?> fetchStreamer({required String username}) async {
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
    bool isLive;
    String profileImageUrl;
    String description;
    String displayName;
    try {
      final script = scriptTag.first.text;
      final List<dynamic> json = jsonDecode(script);

      final dict = json.first;
      isLive = dict['publication']['isLiveBroadcast'] ?? false;
      profileImageUrl = dict['thumbnailUrl'].last ?? '';
      description = dict['description'] ?? '';
      displayName = dict['name'].split(' ').first ?? username;
    } catch (e) {
      isLive = false;
      profileImageUrl = '';
      description = '';
      displayName = username;
    }
    return TwitchStreamerModel(
      username: username,
      displayName: displayName,
      description: description,
      profileImageUrl: profileImageUrl,
      isLive: isLive,
    );
  }

  Future<void> refreshStreamers() async {
    final List<TwitchStreamerModel> streamers = state;
    final List<Future<TwitchStreamerModel?>> futures = streamers
        .map((streamer) => fetchStreamer(username: streamer.username))
        .toList();
    final List<TwitchStreamerModel?> updatedStreamers =
        await Future.wait(futures);
    state = updatedStreamers.whereType<TwitchStreamerModel>().toList();
    showToast(message: 'Streamers refreshed');
    debugPrint('Streamers refreshed');
    await saveStreamers();
  }

  Future<void> addStreamer(TwitchStreamerModel streamer) async {
    if (state.any((s) => s.username == streamer.username)) {
      showToast(message: 'Streamer already exists');
      debugPrint('Streamer already exists');
      return;
    }
    state = [...state, streamer];
    showToast(message: 'Streamer added');
    debugPrint('Streamer added');
    await saveStreamers();
  }

  Future<void> removeStreamer(TwitchStreamerModel streamer) async {
    if (!state.any((s) => s.username == streamer.username)) {
      showToast(message: 'Streamer does not exist');
      debugPrint('Streamer does not exist');
      return;
    }
    state = state.where((s) => s.username != streamer.username).toList();
    showToast(message: 'Streamer removed');
    debugPrint('Streamer removed');
    await saveStreamers();
  }

  Future<void> reorderStreamer({
    required int oldIndex,
    required int newIndex,
  }) async {
    if (oldIndex == newIndex) {
      showToast(message: 'Same index');
      debugPrint('Same index');
      return;
    }
    final streamers = state;
    final streamer = streamers.removeAt(oldIndex);
    streamers.insert(newIndex, streamer);
    state = streamers;
    // showToast(message: 'Streamer reordered');
    debugPrint('Streamer reordered');
    await saveStreamers();
  }

  Future<void> refreshStreamer(TwitchStreamerModel streamer) async {
    final c = await fetchStreamer(username: streamer.username);
    final updatedStreamer = c ?? streamer;
    final index = state.indexWhere((s) => s.username == streamer.username);
    state[index] = updatedStreamer;
    showToast(message: 'Streamer refreshed');
    debugPrint('Streamer refreshed');
    await saveStreamers();
  }

  String encodeStreamers() {
    return jsonEncode(state.map((c) => c.toJson()).toList());
  }

  void decodeStreamers(String json) {
    final List<dynamic> decodedJson = jsonDecode(json);
    state = decodedJson.map((c) => TwitchStreamerModel.fromJson(c)).toList();
    // showToast(message: 'Streamers loaded');
    debugPrint('${state.length} Streamer(s) loaded');
  }

  Future<void> saveStreamers() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('zyron_streamers', encodeStreamers());
    showToast(message: 'Streamers saved');
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
      showToast(message: 'Streamers exported');
      debugPrint('Streamers exported');
      return true;
    } catch (e) {
      showToast(message: 'Export Streamers Error: $e');
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
      showToast(message: 'Restore Streamers Error: $e');
      debugPrint('Load Streamers Error: $e');
      return false;
    }
  }
}

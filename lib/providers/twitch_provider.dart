import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart' show debugPrint;
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
    final response = await http.get(
      Uri.parse('https://www.twitch.tv/$username'),
    );
    if (response.statusCode != 200) {
      return null;
    }
    final body = response.body;
    final isLive = body.contains('isLiveBroadcast');
    final profileImageUrl =
        body.split('profile-image')[1].split('src="')[1].split('"')[0];
    final displayName =
        body.split('channel-header__user')[1].split('title="')[1].split('"')[0];
    return TwitchStreamerModel(
      username: username,
      displayName: displayName,
      profileImageUrl: profileImageUrl,
      isLive: isLive,
    );
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

import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart' show debugPrint;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zyron/models/app_settings_model.dart';
import 'package:zyron/models/player_settings_model.dart';

part 'app_settings_provider.g.dart';

@Riverpod(keepAlive: true)
class AppSettings extends _$AppSettings {
  @override
  AppSettingsModel build() {
    return reset(returnState: true)!;
  }

  void setDarkMode(bool isDarkMode) {
    state = state.copyWith(isDarkMode: isDarkMode);
  }

  void setAlwaysOnTop(bool isAlwaysOnTop) {
    state = state.copyWith(isAlwaysOnTop: isAlwaysOnTop);
  }

  void setPreventClose(bool isPreventClose) {
    state = state.copyWith(isPreventClose: isPreventClose);
  }

  void setAutoStart(bool isAutoStart) {
    state = state.copyWith(isAutoStart: isAutoStart);
  }

  void setStartingPage(int startingPage) {
    state = state.copyWith(startingPage: startingPage);
  }

  void setPlayerQuality(String quality) {
    state = state.copyWith(
      playerSettings: state.playerSettings.copyWith(quality: quality),
    );
  }

  // void setPlayerMuted(bool isMuted) {
  //   state = state.copyWith(
  //     playerSettings: state.playerSettings.copyWith(isMuted: isMuted),
  //   );
  // }

  void setPlayerVolume(double volume) {
    state = state.copyWith(
      playerSettings: state.playerSettings.copyWith(volume: volume),
    );
  }

  void setPlayerExitOnDone(bool exitOnDone) {
    state = state.copyWith(
      playerSettings: state.playerSettings.copyWith(exitOnDone: exitOnDone),
    );
  }

  void setPlayerMpvExe(String mpvExe) {
    state = state.copyWith(
      playerSettings: state.playerSettings.copyWith(mpvExe: mpvExe),
    );
  }

  void setPlayerMpvWindowSizeX(int mpvWindowSizeX) {
    state = state.copyWith(
      playerSettings:
          state.playerSettings.copyWith(mpvWindowSizeX: mpvWindowSizeX),
    );
  }

  void setPlayerMpvWindowSizeY(int mpvWindowSizeY) {
    state = state.copyWith(
      playerSettings:
          state.playerSettings.copyWith(mpvWindowSizeY: mpvWindowSizeY),
    );
  }

  void setPlayerMpvWindowPosX(int mpvWindowPosX) {
    state = state.copyWith(
      playerSettings:
          state.playerSettings.copyWith(mpvWindowPosX: mpvWindowPosX),
    );
  }

  void setPlayerMpvWindowPosY(int mpvWindowPosY) {
    state = state.copyWith(
      playerSettings:
          state.playerSettings.copyWith(mpvWindowPosY: mpvWindowPosY),
    );
  }

  void setPlayerAutoPlay(bool isAutoPlay) {
    state = state.copyWith(
      playerSettings: state.playerSettings.copyWith(isAutoPlay: isAutoPlay),
    );
  }

  AppSettingsModel? reset({bool returnState = false}) {
    state = AppSettingsModel(
      isDarkMode: true,
      isAlwaysOnTop: true,
      isPreventClose: true,
      isAutoStart: false,
      startingPage: 0,
      playerSettings: PlayerSettingsModel(
        quality: 'best',
        // isMuted: false,
        volume: 75,
        exitOnDone: false,
        mpvExe: 'mpv',
        mpvWindowSizeX: 0,
        mpvWindowSizeY: 0,
        mpvWindowPosX: 0,
        mpvWindowPosY: 0,
        isAutoPlay: false,
      ),
    );
    if (returnState) {
      return state;
    }
    return null;
  }

  Future<void> saveSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedJson = jsonEncode(state.toJson());
    await prefs.setString('zyron_settings', encodedJson);
  }

  Future<AppSettingsModel> loadSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? json = prefs.getString('zyron_settings');

    if (json == null) {
      return reset(returnState: true)!;
    }

    Map<String, dynamic> decodedJson = jsonDecode(json);
    state = AppSettingsModel.fromJson(decodedJson);
    return state;
  }

  Future<bool> exportSettings() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory == null) {
      return false;
    }

    try {
      File file = File('$selectedDirectory/zyron_settings.json');
      String encodedJson = jsonEncode(state.toJson());
      await file.writeAsString(encodedJson);

      return true;
    } catch (e) {
      debugPrint('Save Settings Error: $e');

      return false;
    }
  }

  Future<bool> restoreSettings() async {
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
      Map<String, dynamic> decodedJson = jsonDecode(json);

      state = AppSettingsModel.fromJson(decodedJson);

      return true;
    } catch (e) {
      debugPrint('Load Settings Error: $e');

      return false;
    }
  }
}

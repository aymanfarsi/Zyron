import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zyron/models/app_settings_model.dart';
import 'package:zyron/models/player_settings_model.dart';

part 'app_settings_provider.g.dart';

@riverpod
class AppSettings extends _$AppSettings {
  @override
  AppSettingsModel build() {
    return AppSettingsModel(
      isDarkMode: true,
      isAlwaysOnTop: true,
      isPreventClose: true,
      isAutoStart: false,
      startingPage: 0,
      playerSettings: PlayerSettingsModel(
        quality: 'best',
        isMuted: false,
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

  void setPlayerMuted(bool isMuted) {
    state = state.copyWith(
      playerSettings: state.playerSettings.copyWith(isMuted: isMuted),
    );
  }

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

  void reset() {
    state = build();
  }
}

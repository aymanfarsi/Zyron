import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zyron/models/player_settings_model.dart';

part 'app_settings_model.freezed.dart';
part 'app_settings_model.g.dart';

@freezed
class AppSettingsModel with _$AppSettingsModel {
  factory AppSettingsModel({
    required bool isDarkMode,
    required bool isAlwaysOnTop,
    required bool isPreventClose,
    required bool isAutoStart,
    required bool isMaximizedOnStart,
    required int startingPage,
    required PlayerSettingsModel playerSettings,
  }) = _AppSettingsModel;

  factory AppSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsModelFromJson(json);
}

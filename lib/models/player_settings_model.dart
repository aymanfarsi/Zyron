import 'package:freezed_annotation/freezed_annotation.dart';

part 'player_settings_model.freezed.dart';
part 'player_settings_model.g.dart';

@freezed
class PlayerSettingsModel with _$PlayerSettingsModel {
  factory PlayerSettingsModel({
    required String quality,
    required bool isMuted,
    required double volume,
    required bool exitOnDone,
    required String mpvExe,
    required int mpvWindowSizeX,
    required int mpvWindowSizeY,
    required int mpvWindowPosX,
    required int mpvWindowPosY,
    required bool isAutoPlay,
  }) = _PlayerSettingsModel;

  factory PlayerSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$PlayerSettingsModelFromJson(json);
}

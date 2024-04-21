// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlayerSettingsModelImpl _$$PlayerSettingsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PlayerSettingsModelImpl(
      quality: json['quality'] as String,
      isMuted: json['isMuted'] as bool,
      volume: (json['volume'] as num).toDouble(),
      exitOnDone: json['exitOnDone'] as bool,
      mpvExe: json['mpvExe'] as String,
      mpvWindowSizeX: json['mpvWindowSizeX'] as int,
      mpvWindowSizeY: json['mpvWindowSizeY'] as int,
      mpvWindowPosX: json['mpvWindowPosX'] as int,
      mpvWindowPosY: json['mpvWindowPosY'] as int,
      isAutoPlay: json['isAutoPlay'] as bool,
    );

Map<String, dynamic> _$$PlayerSettingsModelImplToJson(
        _$PlayerSettingsModelImpl instance) =>
    <String, dynamic>{
      'quality': instance.quality,
      'isMuted': instance.isMuted,
      'volume': instance.volume,
      'exitOnDone': instance.exitOnDone,
      'mpvExe': instance.mpvExe,
      'mpvWindowSizeX': instance.mpvWindowSizeX,
      'mpvWindowSizeY': instance.mpvWindowSizeY,
      'mpvWindowPosX': instance.mpvWindowPosX,
      'mpvWindowPosY': instance.mpvWindowPosY,
      'isAutoPlay': instance.isAutoPlay,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppSettingsModelImpl _$$AppSettingsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$AppSettingsModelImpl(
      isDarkMode: json['isDarkMode'] as bool,
      isAlwaysOnTop: json['isAlwaysOnTop'] as bool,
      isPreventClose: json['isPreventClose'] as bool,
      isAutoStart: json['isAutoStart'] as bool,
      startingPage: json['startingPage'] as int,
      playerSettings: PlayerSettingsModel.fromJson(
          json['playerSettings'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AppSettingsModelImplToJson(
        _$AppSettingsModelImpl instance) =>
    <String, dynamic>{
      'isDarkMode': instance.isDarkMode,
      'isAlwaysOnTop': instance.isAlwaysOnTop,
      'isPreventClose': instance.isPreventClose,
      'isAutoStart': instance.isAutoStart,
      'startingPage': instance.startingPage,
      'playerSettings': instance.playerSettings,
    };

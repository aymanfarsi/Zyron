// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'youtube_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$YouTubeModelImpl _$$YouTubeModelImplFromJson(Map<String, dynamic> json) =>
    _$YouTubeModelImpl(
      channels: (json['channels'] as List<dynamic>)
          .map((e) => YouTubeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$YouTubeModelImplToJson(_$YouTubeModelImpl instance) =>
    <String, dynamic>{
      'channels': instance.channels,
    };

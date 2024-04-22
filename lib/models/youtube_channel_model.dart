import 'package:freezed_annotation/freezed_annotation.dart';

part 'youtube_channel_model.freezed.dart';
part 'youtube_channel_model.g.dart';

@freezed
class YouTubeChannelModel with _$YouTubeChannelModel {
  factory YouTubeChannelModel({
    required String id,
    required String name,
    required String url,
    required String logo,
    required int subscribers,
  }) = _YouTubeChannelModel;

  factory YouTubeChannelModel.fromJson(Map<String, dynamic> json) =>
      _$YouTubeChannelModelFromJson(json);
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'youtube_video_model.freezed.dart';
part 'youtube_video_model.g.dart';

@freezed
class YouTubeVideoModel with _$YouTubeVideoModel {
  factory YouTubeVideoModel({
    required String id,
    required String title,
    required Duration? duration,
    required DateTime? publishedDate,
    required String highResThumbnail,
    required String url,
  }) = _YouTubeVideoModel;

  factory YouTubeVideoModel.fromJson(Map<String, dynamic> json) =>
      _$YouTubeVideoModelFromJson(json);
}

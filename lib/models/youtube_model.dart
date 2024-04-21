import 'package:freezed_annotation/freezed_annotation.dart';

part 'youtube_model.freezed.dart';
part 'youtube_model.g.dart';

@freezed
class YouTubeModel with _$YouTubeModel {
  factory YouTubeModel({
    required List<YouTubeModel> channels,
  }) = _YouTubeModel;

  factory YouTubeModel.fromJson(Map<String, dynamic> json) =>
      _$YouTubeModelFromJson(json);
}

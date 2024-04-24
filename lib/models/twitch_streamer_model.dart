import 'package:freezed_annotation/freezed_annotation.dart';

part 'twitch_streamer_model.freezed.dart';
part 'twitch_streamer_model.g.dart';

@freezed
class TwitchStreamerModel with _$TwitchStreamerModel {
  factory TwitchStreamerModel({
    required String username,
    required String displayName,
    required String profileImageUrl,
    required bool isLive,
  }) = _TwitchStreamerModel;

  factory TwitchStreamerModel.fromJson(Map<String, dynamic> json) =>
      _$TwitchStreamerModelFromJson(json);
}

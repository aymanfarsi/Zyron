import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:zyron/models/youtube_video_model.dart';

part 'videos_provider.g.dart';

@Riverpod(keepAlive: true)
class VideosList extends _$VideosList {
  @override
  Future<List<YouTubeVideoModel>> build() async {
    return [];
  }

  Future<void> fetchVideos({required String channelId}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final httpClient = YoutubeHttpClient();
      final channelClient = ChannelClient(httpClient);
      final results = await channelClient.getUploadsFromPage(channelId);

      List<YouTubeVideoModel> videos = [];
      for (final video in results) {
        videos.add(YouTubeVideoModel(
          id: video.id.value,
          title: video.title,
          duration: video.duration,
          publishedDate: video.uploadDate,
          highResThumbnail: video.thumbnails.highResUrl,
          url: 'https://www.youtube.com/watch?v=${video.id.value}',
        ));
      }

      return videos;
    });
  }
}
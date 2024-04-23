import 'package:fluent_ui/fluent_ui.dart' hide ListTile, Card, Colors;
import 'package:flutter/material.dart' hide ButtonStyle;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:zyron/models/youtube_video_model.dart';
import 'package:zyron/providers/app_settings_provider.dart';
import 'package:zyron/providers/videos_provider.dart';
import 'package:zyron/providers/youtube_provider.dart';
import 'package:zyron/src/utils.dart';
import 'package:zyron/views/components.dart';

class ListChannels extends HookConsumerWidget {
  const ListChannels({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appSettings = ref.watch(appSettingsProvider);

    final selectedIndex = useState<int?>(null);
    final ytList = ref.watch(youTubeListProvider);

    final ValueNotifier<YouTubeVideoModel?> selectedVideo = useState(null);
    final videoList = ref.watch(videosListProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 175.0,
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              scrollbars: false,
              physics: const BouncingScrollPhysics(),
            ),
            child: ListView.builder(
              shrinkWrap: false,
              itemCount: ytList.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return MouseRegion(
                  cursor: SystemMouseCursors.basic,
                  child: Card(
                    elevation: 2.0,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    color: selectedIndex.value == index
                        ? Colors.amber.withOpacity(0.2)
                        : Colors.transparent,
                    child: ListTile(
                      visualDensity: VisualDensity.compact,
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      selected: selectedIndex.value == index,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 8.0),
                      title: Text(
                        ytList[index].name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      subtitle: Text(
                        formatSubscribers(ytList[index].subscribers),
                        style: const TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          ytList[index].logo,
                        ),
                      ),
                      onTap: () async {
                        selectedIndex.value = index;
                        await ref.read(videosListProvider.notifier).fetchVideos(
                            channelId: ytList[selectedIndex.value!].id);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const Gap(9.0),
        SizedBox(
          width: MediaQuery.of(context).size.width - 261.0,
          height: MediaQuery.of(context).size.height - 129.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height -
                    (selectedVideo.value == null ? 129.0 : 259.0),
                padding: const EdgeInsets.all(8.0),
                decoration: boxDecoration,
                child: videoList.when(
                  data: (videos) {
                    return ListView.builder(
                      shrinkWrap: false,
                      itemCount: videos.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 2.0,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                          child: ListTile(
                            leading: Container(
                              width: 100.0,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12.0),
                                  bottomLeft: Radius.circular(12.0),
                                ),
                              ),
                              child: Image.network(
                                videos[index].highResThumbnail,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              videos[index].title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            subtitle: Text(
                              formatDuration(videos[index].duration),
                              style: const TextStyle(
                                fontSize: 12.0,
                              ),
                            ),
                            trailing: Text(
                              formatPublishedDate(videos[index].publishedDate),
                              style: const TextStyle(
                                fontSize: 12.0,
                              ),
                            ),
                            onTap: () {
                              selectedVideo.value = videos[index];
                            },
                          ),
                        );
                      },
                    );
                  },
                  error: (error, stackTrace) {
                    return Center(
                      child: Text(
                        'Error: $error',
                      ),
                    );
                  },
                  loading: () {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
              Visibility(
                visible: selectedVideo.value != null,
                child: const Gap(9.0),
              ),
              Visibility(
                visible: selectedVideo.value != null,
                child: Container(
                  height: 121.0,
                  padding: const EdgeInsets.all(8.0),
                  decoration: boxDecoration,
                  child: Center(
                    child: Button(
                      child: const Text(
                        'Play',
                      ),
                      onPressed: () async {
                        await watchVideo(
                          selectedVideo.value!,
                          appSettings.playerSettings,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

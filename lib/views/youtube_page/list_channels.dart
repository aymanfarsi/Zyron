import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:zyron/models/youtube_video_model.dart';
import 'package:zyron/providers/app_settings_provider.dart';
import 'package:zyron/providers/videos_provider.dart';
import 'package:zyron/providers/youtube_provider.dart';
import 'package:zyron/src/utils.dart';
import 'package:zyron/views/components.dart';

// ignore: constant_identifier_names
const int FETCH_ALL_VIDEOS_LIMIT = 3;

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
        Container(
          padding: const EdgeInsets.only(top: 8.0),
          width: 175.0,
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              scrollbars: false,
              physics: const BouncingScrollPhysics(),
            ),
            child: ytList.isEmpty
                ? const Center(
                    child: Text(
                      'No channels',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14.0,
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: false,
                    itemCount: ytList.length + 1,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return SizedBox(
                          height: 50.0,
                          child: Center(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
                                  selectedIndex.value == -1
                                      ? Colors.amber.withOpacity(0.2)
                                      : Colors.transparent,
                                ),
                                elevation: WidgetStateProperty.all(2.0),
                              ),
                              onPressed: () async {
                                selectedVideo.value = null;
                                selectedIndex.value = -1;
                                await ref
                                    .read(videosListProvider.notifier)
                                    .fetchVideosFromChannels(
                                      channelIds:
                                          ytList.map((e) => e.id).toList(),
                                      maxVideos: FETCH_ALL_VIDEOS_LIMIT,
                                    );
                              },
                              child: const Text(
                                'Fetch All Videos',
                              ),
                            ),
                          ),
                        );
                      }
                      return MouseRegion(
                        cursor: SystemMouseCursors.basic,
                        child: Card(
                          elevation: 2.0,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                          color: selectedIndex.value == index - 1
                              ? Colors.amber.withOpacity(0.2)
                              : Colors.transparent,
                          child: ListTile(
                            visualDensity: VisualDensity.compact,
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            selected: selectedIndex.value == index - 1,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            title: Text(
                              ytList[index - 1].name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            subtitle: Text(
                              formatSubscribers(ytList[index - 1].subscribers),
                              style: const TextStyle(
                                fontSize: 12.0,
                              ),
                            ),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                ytList[index - 1].logo,
                              ),
                            ),
                            onTap: () async {
                              selectedVideo.value = null;
                              selectedIndex.value = index - 1;
                              await ref
                                  .read(videosListProvider.notifier)
                                  .fetchVideos(
                                      channelId:
                                          ytList[selectedIndex.value!].id);
                            },
                          ),
                        ),
                      );
                    },
                    // onReorder: (int oldIndex, int newIndex) async {
                    //   await ref.read(youTubeListProvider.notifier).reorderChannel(
                    //         oldIndex: oldIndex,
                    //         newIndex: newIndex,
                    //       );
                    // },
                  ),
          ),
        ),
        const Gap(9.0),
        Container(
          padding: const EdgeInsets.only(top: 8.0),
          width: MediaQuery.of(context).size.width - 261.0,
          height: MediaQuery.of(context).size.height - 129.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height -
                    (selectedVideo.value == null ? 179.0 : 309.0),
                padding: const EdgeInsets.all(8.0),
                decoration: boxDecoration,
                child: videoList.when(
                  data: (videos) {
                    if (videos.isEmpty) {
                      return const Center(
                        child: Text(
                          'No videos',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 14.0,
                          ),
                        ),
                      );
                    }

                    List<Widget> videoWidgets = [];
                    for (int index = 0; index < videos.length; index++) {
                      if (index % FETCH_ALL_VIDEOS_LIMIT == 0 &&
                          selectedIndex.value == -1) {
                        videoWidgets.add(
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            height: 50.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Expanded(
                                  child: Divider(),
                                ),
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    ytList[index ~/ FETCH_ALL_VIDEOS_LIMIT]
                                        .logo,
                                  ),
                                ),
                                const Gap(9.0),
                                Text(
                                  ytList[index ~/ FETCH_ALL_VIDEOS_LIMIT].name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                  ),
                                ),
                                const Expanded(
                                  child: Divider(),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      videoWidgets.add(
                        Card(
                          elevation: 2.0,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                          color: selectedVideo.value == videos[index]
                              ? Colors.amber.withOpacity(0.2)
                              : Colors.transparent,
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
                            title: Tooltip(
                              message: videos[index].title,
                              child: Text(
                                videos[index].title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
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
                        ),
                      );
                    }
                    return ListView(
                      shrinkWrap: false,
                      children: videoWidgets,
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          selectedVideo.value?.title ?? 'Unknown',
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 14.0,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            child: const Text(
                              'Close',
                            ),
                            onPressed: () {
                              selectedVideo.value = null;
                            },
                          ),
                          ElevatedButton(
                            child: const Text(
                              'Copy Link',
                            ),
                            onPressed: () async {
                              await copyToClipboard(
                                selectedVideo.value!.url,
                              );
                            },
                          ),
                          Container(
                            // padding: const EdgeInsets.all(8.0),
                            height: 75.0,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12.0),
                                bottomLeft: Radius.circular(12.0),
                              ),
                            ),
                            child: selectedVideo.value == null
                                ? const Placeholder()
                                : Image.network(
                                    selectedVideo.value!.highResThumbnail,
                                    fit: BoxFit.fitWidth,
                                  ),
                          ),
                          ElevatedButton(
                            child: const Text(
                              'Watch',
                            ),
                            onPressed: () async {
                              await watchVideo(
                                channelName: selectedIndex.value == -1
                                    ? 'All Channels'
                                    : ytList[selectedIndex.value!].name,
                                video: selectedVideo.value!,
                                player: appSettings.playerSettings,
                              );
                            },
                          ),
                        ],
                      ),
                    ],
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

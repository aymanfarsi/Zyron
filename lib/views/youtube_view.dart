import 'package:desktop_context_menu/desktop_context_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:zyron/providers/youtube_provider.dart';
import 'package:zyron/views/components.dart';

enum YouTubeViewType {
  start,
  searching,
  results;

  String get message {
    switch (this) {
      case YouTubeViewType.start:
        return 'Search YouTube';
      case YouTubeViewType.searching:
        return 'Searching...';
      case YouTubeViewType.results:
        return 'No results found';
    }
  }
}

class YouTubeView extends HookConsumerWidget {
  const YouTubeView({super.key});

  String _formatSubscribers(int subscribers) {
    if (subscribers == -1) {
      return 'Subscribers: Unknown';
    } else if (subscribers < 10e3) {
      return 'Subscribers: $subscribers';
    } else if (subscribers < 10e6) {
      double sub = subscribers / 10e3;
      return 'Subscribers: ${sub.toStringAsFixed(1)}K';
    } else {
      double sub = subscribers / 10e6;
      return 'Subscribers: ${sub.toStringAsFixed(1)}M';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewType = useState(YouTubeViewType.start);

    final searchList = useState([]);
    final searchQuery = useTextEditingController();

    return Container(
      decoration: boxDecoration,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 40.0,
                width: 500.0,
                child: TextField(
                  controller: searchQuery,
                  decoration: const InputDecoration(
                    hintText: 'Search YouTube',
                  ),
                  onSubmitted: (value) async {
                    searchList.value = [];
                    viewType.value = YouTubeViewType.searching;
                    searchList.value =
                        await ref.read(youTubeListProvider.notifier).search(
                              query: searchQuery.text,
                            );
                    viewType.value = YouTubeViewType.results;
                  },
                ),
              ),
              const Gap(20.0),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () async {
                  searchList.value = [];
                  viewType.value = YouTubeViewType.searching;
                  searchList.value =
                      await ref.read(youTubeListProvider.notifier).search(
                            query: searchQuery.text,
                          );
                  viewType.value = YouTubeViewType.results;
                },
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height - 118.0,
            width: MediaQuery.of(context).size.width,
            child: searchList.value.isEmpty
                ? Center(
                    child: Text(
                      viewType.value.message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: searchList.value.length,
                    itemBuilder: (context, index) {
                      final channel = searchList.value[index];
                      return GestureDetector(
                        onSecondaryTap: () async {
                          final item = await showContextMenu(
                            menuItems: [
                              ContextMenuItem(
                                title: 'Add to list',
                                onTap: () {},
                              ),
                              const ContextMenuSeparator(),
                              ContextMenuItem(
                                title: 'Cancel',
                                onTap: () {},
                              ),
                            ],
                          );
                          if (item == null) {
                            return;
                          }
                          await ref
                              .read(youTubeListProvider.notifier)
                              .addChannel(
                                channel,
                              );
                        },
                        child: ListTile(
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          leading: CircleAvatar(
                            backgroundImage: channel.logo.isEmpty
                                ? null
                                : NetworkImage(channel.logo),
                            backgroundColor: Colors.transparent,
                          ),
                          title: Text(channel.name),
                          subtitle: Text(
                            _formatSubscribers(channel.subscribers),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

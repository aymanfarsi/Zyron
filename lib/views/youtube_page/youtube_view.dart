import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:zyron/providers/youtube_provider.dart';
import 'package:zyron/views/youtube_page/list_channels.dart';
import 'package:zyron/views/youtube_page/manage_channels.dart';
import 'package:zyron/views/youtube_page/search_channels.dart';

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabIndex = useState(0);
    final ytList = ref.watch(youTubeListProvider);

    return DefaultTabController(
      initialIndex: tabIndex.value,
      length: 3,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 3.0),
                child: Center(
                  child: Text(
                    '${ytList.length} Channels',
                  ),
                ),
              ),
            ],
          ),
          TabBar(
            onTap: (index) {
              tabIndex.value = index;
            },
            tabs: const <Widget>[
              Tab(
                text: 'Channels',
                icon: Icon(Icons.video_collection_outlined),
              ),
              Tab(
                text: 'Search',
                icon: Icon(Icons.search_outlined),
              ),
              Tab(
                text: 'Manage',
                icon: Icon(Icons.manage_accounts_outlined),
              ),
            ],
          ),
          const Expanded(
            child: TabBarView(
              children: [
                ListChannels(),
                SearchChannel(),
                ManageChannels(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

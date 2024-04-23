import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' show Icons;
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

    return TabView(
      currentIndex: tabIndex.value,
      onChanged: (index) => tabIndex.value = index,
      tabWidthBehavior: TabWidthBehavior.equal,
      minTabWidth: 75.0,
      maxTabWidth: 125.0,
      closeButtonVisibility: CloseButtonVisibilityMode.never,
      showScrollButtons: false,
      shortcutsEnabled: false,
      footer: Padding(
        padding: const EdgeInsets.only(right: 3.0),
        child: Center(
          child: Text(
            '${ytList.length} Channels',
          ),
        ),
      ),
      tabs: [
        Tab(
          text: const Center(child: Text('Channels')),
          icon: const Icon(Icons.video_collection_outlined),
          body: const ListChannels(),
        ),
        Tab(
          text: const Center(child: Text('Search')),
          icon: const Icon(Icons.search_outlined),
          body: const SearchChannel(),
        ),
        Tab(
          text: const Center(child: Text('Manage')),
          icon: const Icon(Icons.manage_accounts_outlined),
          body: const ManageChannels(),
        ),
      ],
    );
  }
}

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:zyron/providers/twitch_provider.dart';
import 'package:zyron/views/twitch_page/list_streamers.dart';
import 'package:zyron/views/twitch_page/manage_streamers.dart';

class TwitchView extends HookConsumerWidget {
  const TwitchView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final twitchList = ref.watch(twitchListProvider);

    final tabIndex = useState<int>(0);

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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '${twitchList.where((t) => t.isLive).length} Live Channels',
            ),
            const Gap(9),
            Button(
              style: ButtonStyle(
                elevation: ButtonState.all(2.0),
              ),
              onPressed: () async {
                await ref.read(twitchListProvider.notifier).refreshStreamers();
              },
              child: const Text(
                'Refresh ',
              ),
            ),
          ],
        ),
      ),
      tabs: [
        Tab(
          text: const Center(child: Text('Streamers')),
          icon: const Icon(Icons.video_collection_outlined),
          body: const ListStreamers(),
        ),
        Tab(
          text: const Center(child: Text('Manage')),
          icon: const Icon(Icons.manage_accounts_outlined),
          body: const ManageStreamers(),
        ),
      ],
    );
  }
}

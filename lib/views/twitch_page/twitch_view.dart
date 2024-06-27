import 'package:flutter/material.dart';
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
    final isFetching = useState<bool>(false);

    return DefaultTabController(
      initialIndex: tabIndex.value,
      length: 2,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 3.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${twitchList.where((t) => t.isLive).length} Live Channels',
                    ),
                    const Gap(9),
                    ElevatedButton(
                      style: ButtonStyle(
                        elevation: WidgetStateProperty.all(2.0),
                      ),
                      onPressed: () async {
                        isFetching.value = true;
                        await ref
                            .read(twitchListProvider.notifier)
                            .refreshStreamers();
                        isFetching.value = false;
                      },
                      child: const Text(
                        'Refresh ',
                      ),
                    ),
                  ],
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
                text: 'Streamers',
                icon: Icon(Icons.video_collection_outlined),
              ),
              Tab(
                text: 'Manage',
                icon: Icon(Icons.manage_accounts_outlined),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TabBarView(
                children: <Widget>[
                  isFetching.value
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : const ListStreamers(),
                  const ManageStreamers(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

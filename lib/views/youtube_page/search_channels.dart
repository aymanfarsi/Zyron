import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:zyron/providers/youtube_provider.dart';
import 'package:zyron/src/utils.dart';
import 'package:zyron/views/components.dart';
import 'package:zyron/views/youtube_page/youtube_view.dart';

class SearchChannel extends HookConsumerWidget {
  const SearchChannel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewType = useState(YouTubeViewType.start);

    final searchList = useState([]);
    final searchQuery = useTextEditingController();
    final addedChannels = ref.watch(youTubeListProvider);

    return Container(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        decoration: boxDecoration,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(9.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40.0,
                  width: 500.0,
                  child: TextField(
                    controller: searchQuery,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(8.0),
                      hintText: 'Search YouTube',
                    ),
                    onSubmitted: (value) async {
                      searchList.value = [];
                      viewType.value = YouTubeViewType.searching;
                      searchList.value = await ref
                          .read(youTubeListProvider.notifier)
                          .search(query: searchQuery.text);
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
                    searchList.value = await ref
                        .read(youTubeListProvider.notifier)
                        .search(query: searchQuery.text);
                    viewType.value = YouTubeViewType.results;
                  },
                ),
              ],
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 238.1,
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
                  : Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.05),
                      child: ListView.builder(
                        shrinkWrap: false,
                        itemCount: searchList.value.length,
                        itemBuilder: (context, index) {
                          final channel = searchList.value[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: channel.logo.isEmpty
                                  ? null
                                  : NetworkImage(channel.logo),
                              backgroundColor: Colors.transparent,
                            ),
                            title: Text(channel.name),
                            subtitle: Text(
                              formatSubscribers(channel.subscribers),
                            ),
                            trailing: IconButton(
                              icon: addedChannels.contains(channel)
                                  ? const Icon(Icons.check)
                                  : const Icon(Icons.add),
                              onPressed: () async {
                                await ref
                                    .read(youTubeListProvider.notifier)
                                    .addChannel(channel);
                              },
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

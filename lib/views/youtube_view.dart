import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:zyron/providers/youtube_provider.dart';
import 'package:zyron/views/components.dart';

class YouTubeView extends HookConsumerWidget {
  const YouTubeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ytList = useState([]);
    final searchQuery = useTextEditingController();

    return Container(
      decoration: boxDecoration,
      width: 784.0,
      height: 591.0,
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
                ),
              ),
              const Gap(20.0),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () async {
                  ytList.value =
                      await ref.read(youTubeListProvider.notifier).search(
                            query: searchQuery.text,
                          );
                },
              ),
            ],
          ),
          SizedBox(
            height: 473.0,
            width: 784.0,
            child: ytList.value.isEmpty
                ? const Center(
                    child: Text('No results found.'),
                  )
                : ListView.builder(
                    itemCount: ytList.value.length,
                    itemBuilder: (context, index) {
                      final channel = ytList.value[index];
                      return ListTile(
                        leading: CircleAvatar(
                          child: channel.logo.isEmpty
                              ? Container(
                                  color: Colors.grey,
                                )
                              : Image.network(channel.logo),
                        ),
                        title: Text(channel.name),
                        onTap: () async {
                          // Open channel in browser
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:zyron/providers/app_settings_provider.dart';
import 'package:zyron/providers/twitch_provider.dart';
import 'package:zyron/src/utils.dart';
import 'package:zyron/views/components.dart';

class ListStreamers extends HookConsumerWidget {
  const ListStreamers({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appSettings = ref.watch(appSettingsProvider);

    final selectedIndex = useState<int?>(null);
    final twitchList = ref.watch(twitchListProvider);
    final streamers = twitchList.where((t) => t.isLive).toList();

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
            child: streamers.isEmpty
                ? const Center(
                    child: Text(
                      'No live streamers',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14.0,
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: false,
                    itemCount: streamers.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return MouseRegion(
                        cursor: SystemMouseCursors.basic,
                        child: Card(
                          elevation: 2.0,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
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
                              streamers[index].displayName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            subtitle: Text(
                              streamers[index].username,
                              style: const TextStyle(
                                fontSize: 12.0,
                              ),
                            ),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                streamers[index].profileImageUrl,
                              ),
                            ),
                            onTap: () async {
                              selectedIndex.value = index;
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
        const Gap(9.0),
        Container(
          width: MediaQuery.of(context).size.width - 261.0,
          height: MediaQuery.of(context).size.height - 129.0,
          padding: const EdgeInsets.all(8.0),
          decoration: boxDecoration,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                selectedIndex.value == null
                    ? 'Select a streamer'
                    : streamers[selectedIndex.value!].description,
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14.0,
                ),
                textAlign: TextAlign.justify,
              ),
              const Gap(9.0),
              if (selectedIndex.value != null)
                Container(
                  height: 200.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.5),
                      width: 1.0,
                    ),
                  ),
                  child: Image.network(
                    streamers[selectedIndex.value!].profileImageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              const Gap(9.0),
              if (selectedIndex.value != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await copyToClipboard(
                          streamers[selectedIndex.value!].url!,
                        );
                      },
                      child: const Text('Copy url'),
                    ),
                    const Gap(20),
                    ElevatedButton(
                      onPressed: () async {
                        await watchStream(
                          streamers[selectedIndex.value!],
                          appSettings.playerSettings,
                        );
                      },
                      child: const Text('Watch Stream'),
                    ),
                  ],
                ),
            ],
          ),
        )
      ],
    );
  }
}

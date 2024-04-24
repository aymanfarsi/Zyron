import 'package:fluent_ui/fluent_ui.dart' hide ListTile, Card, Colors;
import 'package:flutter/material.dart' hide ButtonStyle, Divider, Tooltip;
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
    final liveStreamers = twitchList.where((t) => t.isLive).toList();

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
            child: liveStreamers.isEmpty
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
                    itemCount: liveStreamers.length,
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
                              twitchList[index].displayName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            subtitle: Text(
                              twitchList[index].username,
                              style: const TextStyle(
                                fontSize: 12.0,
                              ),
                            ),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                twitchList[index].profileImageUrl,
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
                    : 'Selected streamer: ${liveStreamers[selectedIndex.value!].displayName}',
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14.0,
                ),
              ),
              const Gap(9.0),
              if (selectedIndex.value != null)
                Button(
                  onPressed: () async {
                    await watchStream(
                      liveStreamers[selectedIndex.value!],
                      appSettings.playerSettings,
                    );
                  },
                  child: const Text('Watch Stream'),
                ),
            ],
          ),
        )
      ],
    );
  }
}

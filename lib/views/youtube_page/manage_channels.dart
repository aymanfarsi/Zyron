import 'package:desktop_context_menu/desktop_context_menu.dart';
import 'package:fluent_ui/fluent_ui.dart';
// import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:zyron/providers/youtube_provider.dart';
import 'package:zyron/src/utils.dart';

class ManageChannels extends HookConsumerWidget {
  const ManageChannels({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ytList = ref.watch(youTubeListProvider);

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        scrollbars: false,
        physics: const BouncingScrollPhysics(),
      ),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width ~/ 200,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        shrinkWrap: true,
        itemCount: ytList.length,
        itemBuilder: (context, index) {
          return MouseRegion(
            cursor: SystemMouseCursors.basic,
            child: SizedBox(
              width: 200.0,
              child: GestureDetector(
                onSecondaryTap: () async {
                  await showContextMenu(
                    menuItems: [
                      ContextMenuItem(
                        title: 'Remove',
                        onTap: () async {
                          await showDialog(
                            context: context,
                            builder: (context) {
                              return ContentDialog(
                                title: const Text('Remove Channel'),
                                content: const Text(
                                    'Are you sure you want to remove this channel?'),
                                actions: <Widget>[
                                  Button(
                                    onPressed: () {
                                      context.pop();
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  Button(
                                    onPressed: () async {
                                      await ref
                                          .read(youTubeListProvider.notifier)
                                          .removeChannel(ytList[index]);
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          ButtonState.all(Colors.red),
                                    ),
                                    child: const Text('Remove'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      const ContextMenuSeparator(),
                      ContextMenuItem(
                        title: 'Cancel',
                        onTap: () {},
                      ),
                    ],
                  );
                },
                child: Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                    title: Text(
                      ytList[index].name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    subtitle: Text(
                      formatSubscribers(ytList[index].subscribers),
                      style: const TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        ytList[index].logo,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:desktop_context_menu/desktop_context_menu.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:zyron/providers/youtube_provider.dart';
import 'package:zyron/src/utils.dart';

class ManageChannels extends HookConsumerWidget {
  const ManageChannels({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ytList = ref.watch(youTubeListProvider);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          scrollbars: false,
          physics: const BouncingScrollPhysics(),
        ),
        child: ytList.isEmpty
            ? const Center(
                child: Text(
                  'No channels',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14.0,
                  ),
                ),
              )
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width ~/ 200,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 2.5,
                ),
                shrinkWrap: false,
                itemCount: ytList.length,
                itemBuilder: (context, index) {
                  return MouseRegion(
                    cursor: SystemMouseCursors.basic,
                    child: GestureDetector(
                      onSecondaryTap: () async {
                        final item = await showContextMenu(
                          menuItems: [
                            ContextMenuItem(
                              title: 'Remove',
                              onTap: () async {},
                            ),
                            const ContextMenuSeparator(),
                            ContextMenuItem(
                              title: 'Refresh',
                              onTap: () async {},
                            ),
                          ],
                        );
                        if (item == null) return;
                        if (item.title == 'Remove') {
                          await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Remove Channel'),
                                content: Text(
                                  'Are you sure you want to remove ${ytList[index].name}?',
                                ),
                                actions: <Widget>[
                                  ElevatedButton(
                                    onPressed: () {
                                      context.pop();
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      await ref
                                          .read(youTubeListProvider.notifier)
                                          .removeChannel(ytList[index]);
                                      context.pop();
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          WidgetStateProperty.all(Colors.red),
                                    ),
                                    child: const Text('Remove'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                        if (item.title == 'Refresh') {
                          await ref
                              .read(youTubeListProvider.notifier)
                              .refreshChannel(ytList[index]);
                        }
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ListTile(
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
                            radius: 15.0,
                            backgroundImage: NetworkImage(
                              ytList[index].logo,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                // onReorder: (oldIndex, newIndex) async {
                //   await ref
                //       .read(youTubeListProvider.notifier)
                //       .reorderChannel(oldIndex: oldIndex, newIndex: newIndex);
                // },
              ),
      ),
    );
  }
}

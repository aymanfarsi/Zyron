// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:desktop_context_menu/desktop_context_menu.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:zyron/providers/twitch_provider.dart';

class ManageStreamers extends HookConsumerWidget {
  const ManageStreamers({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final twitchList = ref.watch(twitchListProvider);
    final input = useTextEditingController();

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              scrollbars: false,
              physics: const BouncingScrollPhysics(),
            ),
            child: twitchList.isEmpty
                ? const Center(
                    child: Text(
                      'No streamers',
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
                    itemCount: twitchList.length,
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
                                ContextMenuItem(
                                  title: 'Refresh All',
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
                                      'Are you sure you want to remove ${twitchList[index].displayName}?',
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
                                              .read(twitchListProvider.notifier)
                                              .removeStreamer(
                                                  twitchList[index]);
                                          context.pop();
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStateProperty.all(
                                            Colors.red,
                                          ),
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
                                  .read(twitchListProvider.notifier)
                                  .refreshStreamer(twitchList[index]);
                            }
                            if (item.title == 'Refresh All') {
                              await ref
                                  .read(twitchListProvider.notifier)
                                  .refreshStreamers();
                            }
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: ListTile(
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
                                radius: 15.0,
                                backgroundImage: NetworkImage(
                                  twitchList[index].profileImageUrl,
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
        ),
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: FloatingActionButton(
            onPressed: () async {
              await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Add Streamer'),
                    content: SizedBox(
                      height: 40.0,
                      width: 300.0,
                      child: TextField(
                        controller: input,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          contentPadding: const EdgeInsets.all(8.0),
                          hintText: 'Enter username or paste URL',
                        ),
                        onSubmitted: (value) async {
                          final text = input.text;
                          if (text.isEmpty) return;
                          final username = text.split('/').last;
                          final streamer = await ref
                              .read(twitchListProvider.notifier)
                              .fetchStreamer(username: username);
                          if (streamer == null) {
                            await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Error'),
                                  content: const Text('Streamer not found'),
                                  actions: <Widget>[
                                    ElevatedButton(
                                      onPressed: () {
                                        context.pop();
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                            return;
                          }
                          await ref
                              .read(twitchListProvider.notifier)
                              .addStreamer(streamer);
                          input.clear();
                          context.pop();
                        },
                      ),
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          input.clear();
                          context.pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final text = input.text;
                          if (text.isEmpty) return;
                          final username = text.split('/').last;
                          final streamer = await ref
                              .read(twitchListProvider.notifier)
                              .fetchStreamer(username: username);
                          if (streamer == null) {
                            await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Error'),
                                  content: const Text('Streamer not found'),
                                  actions: <Widget>[
                                    ElevatedButton(
                                      onPressed: () {
                                        context.pop();
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                            return;
                          }
                          await ref
                              .read(twitchListProvider.notifier)
                              .addStreamer(streamer);
                          input.clear();
                          context.pop();
                        },
                        child: const Text('Add'),
                      ),
                    ],
                  );
                },
              );
            },
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}

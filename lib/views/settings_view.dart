import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:zyron/providers/app_settings_provider.dart';
import 'package:zyron/providers/twitch_provider.dart';
import 'package:zyron/providers/youtube_provider.dart';
import 'package:zyron/src/variables.dart';
import 'package:zyron/views/components.dart';

class SettingsView extends HookConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appSettings = ref.watch(appSettingsProvider);

    final mpvController =
        useTextEditingController(text: appSettings.playerSettings.mpvExe);
    final mpvFocusNode = useFocusNode();

    final qualityController =
        useTextEditingController(text: appSettings.playerSettings.quality);
    final qualityFocusNode = useFocusNode();

    return Container(
      decoration: boxDecoration,
      padding: const EdgeInsets.all(12.0),
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          scrollbars: false,
          physics: const BouncingScrollPhysics(),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 40.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      'Settings View',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () async {
                        await ref
                            .read(appSettingsProvider.notifier)
                            .saveSettings();
                      },
                      child: const Text(
                        'Save',
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(16.0),
              _Section(
                header: 'App',
                items: [
                  _SettingItem(
                    title: 'Theme mode',
                    subtitle: 'Toggle dark mode',
                    child: Switch(
                      value: appSettings.isDarkMode,
                      onChanged: (value) {
                        ref
                            .read(appSettingsProvider.notifier)
                            .setDarkMode(value);
                      },
                    ),
                  ),
                  _SettingItem(
                    title: 'Always on Top',
                    subtitle: 'Toggle always on top',
                    child: Switch(
                      value: appSettings.isAlwaysOnTop,
                      onChanged: (value) {
                        ref
                            .read(appSettingsProvider.notifier)
                            .setAlwaysOnTop(value);
                      },
                    ),
                  ),
                  _SettingItem(
                    title: 'Prevent close',
                    subtitle: 'Confirm before closing',
                    child: Switch(
                      value: appSettings.isPreventClose,
                      onChanged: (value) {
                        ref
                            .read(appSettingsProvider.notifier)
                            .setPreventClose(value);
                      },
                    ),
                  ),
                  _SettingItem(
                    title: 'Auto start',
                    subtitle: 'Start app on login',
                    child: Switch(
                      value: appSettings.isAutoStart,
                      onChanged: (value) {
                        ref
                            .read(appSettingsProvider.notifier)
                            .setAutoStart(value);
                      },
                    ),
                  ),
                  _SettingItem(
                    title: 'Maximized on start',
                    subtitle: 'Start app maximized',
                    child: Switch(
                      value: appSettings.isMaximizedOnStart,
                      onChanged: (value) {
                        ref
                            .read(appSettingsProvider.notifier)
                            .setMaximizedOnStart(value);
                      },
                    ),
                  ),
                  _SettingItem(
                    title: 'Starting page',
                    subtitle: 'Select starting page',
                    child: DropdownMenu<String>(
                      initialSelection: appSettings.startingPage.toString(),
                      dropdownMenuEntries: AppPages.values
                          .map(
                            (e) => DropdownMenuEntry(
                              value: e.idx.toString(),
                              label: e.name,
                            ),
                          )
                          .toList(growable: false),
                      onSelected: (String? value) {
                        if (value == null) return;
                        ref
                            .read(appSettingsProvider.notifier)
                            .setStartingPage(int.parse(value));
                      },
                    ),
                  ),
                ],
              ),
              const Gap(16.0),
              _Section(
                header: 'Player',
                items: [
                  _SettingItem(
                    title: 'MPV executable',
                    subtitle:
                        'MPV executable command must be accessible in PATH',
                    child: TextField(
                      focusNode: mpvFocusNode,
                      controller: mpvController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.all(8.0),
                        hintText: 'MPV executable',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.save),
                          onPressed: () {
                            ref
                                .read(appSettingsProvider.notifier)
                                .setPlayerMpvExe(mpvController.text);

                            mpvFocusNode.unfocus();
                          },
                        ),
                      ),
                      onSubmitted: (value) {
                        ref
                            .read(appSettingsProvider.notifier)
                            .setPlayerMpvExe(value);
                      },
                    ),
                  ),
                  _SettingItem(
                    title: 'Quality',
                    subtitle:
                        'Quality settings for player (e.g. 1080p, 720p, etc.)',
                    child: TextField(
                        focusNode: qualityFocusNode,
                        controller: qualityController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          contentPadding: const EdgeInsets.all(8.0),
                          hintText: 'Quality',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.save),
                            onPressed: () {
                              ref
                                  .read(appSettingsProvider.notifier)
                                  .setPlayerQuality(qualityController.text);

                              qualityFocusNode.unfocus();
                            },
                          ),
                        ),
                        onSubmitted: (value) {
                          ref
                              .read(appSettingsProvider.notifier)
                              .setPlayerQuality(value);
                        }),
                  ),
                ],
              ),
              const Gap(16.0),
              // ! Misc
              _Section(
                header: 'Misc',
                items: [
                  // ! Export app settings
                  _SettingItem(
                    title: 'Export app settings',
                    subtitle: 'Export to file',
                    child: ElevatedButton(
                      onPressed: () async {
                        await ref
                            .read(appSettingsProvider.notifier)
                            .exportSettings();
                      },
                      child: const Text(
                        'Export',
                      ),
                    ),
                  ),
                  // ! Restore app settings
                  _SettingItem(
                    title: 'Restore app settings',
                    subtitle: 'Restore all settings',
                    child: ElevatedButton(
                      onPressed: () async {
                        await ref
                            .read(appSettingsProvider.notifier)
                            .restoreSettings();
                      },
                      child: const Text(
                        'Restore',
                      ),
                    ),
                  ),
                  const Divider(),
                  // ! Export YouTube channels list
                  _SettingItem(
                    title: 'Export YouTube channels',
                    subtitle: 'Export to file',
                    child: ElevatedButton(
                      onPressed: () async {
                        await ref
                            .read(youTubeListProvider.notifier)
                            .exportChannels();
                      },
                      child: const Text(
                        'Export',
                      ),
                    ),
                  ),
                  // ! Restore app settings
                  _SettingItem(
                    title: 'Restore YouTube channels',
                    subtitle: 'Restore all channels',
                    child: ElevatedButton(
                      onPressed: () async {
                        await ref
                            .read(youTubeListProvider.notifier)
                            .restoreChannels();
                      },
                      child: const Text(
                        'Restore',
                      ),
                    ),
                  ),
                  const Divider(),
                  // ! Export Twitch streamers list
                  _SettingItem(
                    title: 'Export Twitch streamers',
                    subtitle: 'Export to file',
                    child: ElevatedButton(
                      onPressed: () async {
                        await ref
                            .read(twitchListProvider.notifier)
                            .exportStreamers();
                      },
                      child: const Text(
                        'Export',
                      ),
                    ),
                  ),
                  // ! Restore Twitch streamers list
                  _SettingItem(
                    title: 'Restore Twitch streamers',
                    subtitle: 'Restore all streamers',
                    child: ElevatedButton(
                      onPressed: () async {
                        await ref
                            .read(twitchListProvider.notifier)
                            .restoreStreamers();
                      },
                      child: const Text(
                        'Restore',
                      ),
                    ),
                  ),
                  const Divider(),
                  // ! Reset settings
                  _SettingItem(
                    title: 'Reset settings',
                    subtitle: 'Reset all settings',
                    child: MouseRegion(
                      cursor: SystemMouseCursors.help,
                      child: ElevatedButton(
                        onPressed: () async {
                          await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Reset settings'),
                                content: const Text(
                                  '''Are you sure you want to reset all settings?
This action will reset all app and player settings to default and cannot be undone.
Save after reset to apply changes.''',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                                actions: <Widget>[
                                  ElevatedButton(
                                    onPressed: () {
                                      context.pop();
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      ref
                                          .read(appSettingsProvider.notifier)
                                          .reset();
                                      context.pop();
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          WidgetStateProperty.all(Colors.red),
                                    ),
                                    child: const Text('Confirm'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(Colors.red),
                        ),
                        child: const Text(
                          'Reset',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingItem extends StatelessWidget {
  const _SettingItem({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w400,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 10.0,
          fontWeight: FontWeight.normal,
        ),
      ),
      trailing: SizedBox(
        width: 150.0,
        child: Align(
          alignment: Alignment.centerLeft,
          child: child,
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.header,
    required this.items,
  });

  final String header;
  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: true,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.5),
          width: 0.5,
        ),
      ),
      childrenPadding: const EdgeInsets.all(0),
      title: Text(
        header,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      children: items,
    );
  }
}

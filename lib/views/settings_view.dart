import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:zyron/providers/app_settings_provider.dart';
import 'package:zyron/src/variables.dart';
import 'package:zyron/views/components.dart';

class SettingsView extends HookConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appSettings = ref.watch(appSettingsProvider);
    final mpvController =
        useTextEditingController(text: appSettings.playerSettings.mpvExe);

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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Settings View',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Button(
                      onPressed: () async {
                        await ref
                            .read(appSettingsProvider.notifier)
                            .saveSettings();
                      },
                      child: const Text(
                        'Save',
                      ),
                    )
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
                    child: ToggleSwitch(
                      checked: appSettings.isDarkMode,
                      onChanged: (value) {
                        ref
                            .read(appSettingsProvider.notifier)
                            .setDarkMode(value);
                      },
                      content: Text(
                        appSettings.isDarkMode ? 'Dark' : 'Light',
                      ),
                    ),
                  ),
                  _SettingItem(
                    title: 'Always on Top',
                    subtitle: 'Toggle always on top',
                    child: ToggleSwitch(
                      checked: appSettings.isAlwaysOnTop,
                      onChanged: (value) {
                        ref
                            .read(appSettingsProvider.notifier)
                            .setAlwaysOnTop(value);
                      },
                      content: Text(
                        appSettings.isAlwaysOnTop ? 'On' : 'Off',
                      ),
                    ),
                  ),
                  _SettingItem(
                    title: 'Prevent close',
                    subtitle: 'Confirm before closing',
                    child: ToggleSwitch(
                      checked: appSettings.isPreventClose,
                      onChanged: (value) {
                        ref
                            .read(appSettingsProvider.notifier)
                            .setPreventClose(value);
                      },
                      content: Text(
                        appSettings.isPreventClose ? 'On' : 'Off',
                      ),
                    ),
                  ),
                  _SettingItem(
                    title: 'Auto start',
                    subtitle: 'Start app on login',
                    child: ToggleSwitch(
                      checked: appSettings.isAutoStart,
                      onChanged: (value) {
                        ref
                            .read(appSettingsProvider.notifier)
                            .setAutoStart(value);
                      },
                      content: Text(
                        appSettings.isAutoStart ? 'On' : 'Off',
                      ),
                    ),
                  ),
                  _SettingItem(
                    title: 'Starting page',
                    subtitle: 'Select starting page',
                    child: ComboBox<String>(
                      value: appSettings.startingPage.toString(),
                      items: AppPages.values
                          .map((e) => ComboBoxItem(
                                value: e.idx.toString(),
                                child: Text(
                                  e.name,
                                ),
                              ))
                          .toList(growable: false),
                      onChanged: (String? value) {
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
                    subtitle: 'MPV executable name',
                    child: TextBox(
                      controller: mpvController,
                      placeholder: 'MPV executable',
                      decoration: boxDecoration.copyWith(
                        border: const Border.symmetric(
                          horizontal: BorderSide.none,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      onSubmitted: (value) async {
                        ref
                            .read(appSettingsProvider.notifier)
                            .setPlayerMpvExe(value);
                      },
                      suffix: IconButton(
                        icon: const Icon(FluentIcons.save),
                        style: const ButtonStyle(),
                        onPressed: () async {
                          ref
                              .read(appSettingsProvider.notifier)
                              .setPlayerMpvExe(mpvController.text);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(16.0),
              // ! Misc
              _Section(
                header: 'Misc',
                items: [
                  // ! Export settings
                  _SettingItem(
                    title: 'Export settings',
                    subtitle: 'Export to file',
                    child: Button(
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
                  // ! Restore settings
                  _SettingItem(
                    title: 'Restore settings',
                    subtitle: 'Restore all settings',
                    child: Button(
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
                  // ! Reset settings
                  _SettingItem(
                    title: 'Reset settings',
                    subtitle: 'Reset all settings',
                    child: Button(
                      onPressed: () async {
                        // Confirm reset
                      },
                      style: ButtonStyle(
                        backgroundColor: ButtonState.all(
                          Colors.red,
                        ),
                      ),
                      child: const Text(
                        'Reset',
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
  const _Section({required this.header, required this.items});

  final String header;
  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    return Expander(
      initiallyExpanded: true,
      contentBackgroundColor: Colors.transparent,
      contentShape: (open) {
        return const RoundedRectangleBorder(side: BorderSide.none);
      },
      headerShape: (open) {
        return RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(
            color: Colors.grey.withOpacity(0.5),
            width: 0.5,
          ),
        );
      },
      contentPadding: const EdgeInsets.all(0),
      header: Text(
        header,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        children: items,
      ),
    );
  }
}

import 'package:fluent_ui/fluent_ui.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:zyron/providers/app_settings_provider.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appSettings = ref.watch(appSettingsProvider);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Settings View'),
          const Gap(16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ToggleButton(
                onChanged: (bool v) async {
                  ref.read(appSettingsProvider.notifier).setDarkMode(v);
                },
                checked: appSettings.isDarkMode,
                child: const Text('Toggle Theme'),
              ),
              const SizedBox(width: 8.0),
              ToggleButton(
                onChanged: (bool v) async {
                  ref.read(appSettingsProvider.notifier).setAlwaysOnTop(v);
                },
                checked: appSettings.isAlwaysOnTop,
                child: const Text('Toggle Always On Top'),
              ),
              const SizedBox(width: 8.0),
              ToggleButton(
                onChanged: (bool v) async {
                  ref.read(appSettingsProvider.notifier).setPreventClose(v);
                },
                checked: appSettings.isPreventClose,
                child: const Text('Toggle Prevent Close'),
              ),
            ],
          ),
          const Gap(16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Button(
                onPressed: () async {
                  await ref.read(appSettingsProvider.notifier).saveSettings();
                },
                child: const Text('Save settings'),
              ),
              const SizedBox(width: 8.0),
              Button(
                onPressed: () {
                  ref.read(appSettingsProvider.notifier).reset();
                },
                child: const Text('Reset settings'),
              ),
              const SizedBox(width: 8.0),
              Button(
                onPressed: () async {
                  await ref.read(appSettingsProvider.notifier).loadSettings();
                },
                child: const Text('Load settings'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

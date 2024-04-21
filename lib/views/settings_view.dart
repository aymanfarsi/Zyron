import 'package:flutter/material.dart';
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  ref
                      .read(appSettingsProvider.notifier)
                      .setDarkMode(!appSettings.isDarkMode);
                },
                child: const Text('Toggle Theme'),
              ),
              const SizedBox(width: 8.0),
              ElevatedButton(
                onPressed: () async {
                  ref
                      .read(appSettingsProvider.notifier)
                      .setAlwaysOnTop(!appSettings.isAlwaysOnTop);
                },
                child: const Text('Toggle Always On Top'),
              ),
              const SizedBox(width: 8.0),
              ElevatedButton(
                onPressed: () async {
                  ref
                      .read(appSettingsProvider.notifier)
                      .setPreventClose(!appSettings.isPreventClose);
                },
                child: const Text('Toggle Prevent Close'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:fluent_ui/fluent_ui.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:zyron/providers/app_settings_provider.dart';

class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({super.key});

  @override
  ConsumerState<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> {
  final splitButtonKey = GlobalKey<SplitButtonState>();

  @override
  Widget build(BuildContext context) {
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
          const Gap(16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Button(
                onPressed: () async {
                  await ref.read(appSettingsProvider.notifier).exportSettings();
                },
                child: const Text('Export settings'),
              ),
              const SizedBox(width: 8.0),
              Button(
                onPressed: () async {
                  await ref
                      .read(appSettingsProvider.notifier)
                      .restoreSettings();
                },
                child: const Text('Restore settings'),
              ),
            ],
          ),
          const Gap(16.0),
          SplitButton(
            key: splitButtonKey,
            flyout: FlyoutContent(
              constraints: const BoxConstraints(maxWidth: 250.0),
              child: Wrap(
                runSpacing: 10.0,
                spacing: 8.0,
                children: [
                  for (int i = 0; i < 5; i++)
                    Button(
                      autofocus: appSettings.startingPage == i,
                      style: ButtonStyle(
                        padding: ButtonState.all(
                          const EdgeInsets.all(4.0),
                        ),
                      ),
                      onPressed: () {
                        ref
                            .read(appSettingsProvider.notifier)
                            .setStartingPage(i);
                        context.pop();
                      },
                      child: Text('Page $i'),
                    )
                ],
              ),
            ),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadiusDirectional.horizontal(
                  start: Radius.circular(4.0),
                ),
              ),
              height: 32,
              width: 36,
              alignment: Alignment.center,
              child: Text('Page ${appSettings.startingPage}'),
            ),
          )
        ],
      ),
    );
  }
}

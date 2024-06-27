import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';
import 'package:zyron/providers/app_settings_provider.dart';
import 'package:zyron/providers/twitch_provider.dart';
import 'package:zyron/providers/youtube_provider.dart';
import 'package:zyron/views/skeleton.dart';

class AppFrame extends ConsumerStatefulWidget {
  const AppFrame({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => AppFrameState();
}

class AppFrameState extends ConsumerState<AppFrame>
    with WindowListener, TrayListener {
  @override
  void initState() {
    super.initState();

    trayManager.addListener(this);
    windowManager.addListener(this);

    ref.listenManual(appSettingsProvider, (previous, next) async {
      // ! Always on top
      await windowManager.setAlwaysOnTop(next.isAlwaysOnTop);

      // ! Prevent close
      await windowManager.setPreventClose(next.isPreventClose);

      // ! Auto start
      if (next.isAutoStart) {
        await launchAtStartup.enable();
      } else {
        await launchAtStartup.disable();
      }
    });
  }

  @override
  void dispose() {
    trayManager.removeListener(this);
    windowManager.removeListener(this);
    super.dispose();
  }

  Future<bool> _initAppSettings() async {
    try {
      // ! App settings
      final settings =
          await ref.read(appSettingsProvider.notifier).loadSettings();
      await windowManager.setAlwaysOnTop(settings.isAlwaysOnTop);
      await windowManager.setPreventClose(settings.isPreventClose);
      if (settings.isMaximizedOnStart) {
        await windowManager.maximize();
      }
      if (settings.isAutoStart) {
        await launchAtStartup.enable();
      } else {
        await launchAtStartup.disable();
      }

      // ! YouTube channels
      await ref.read(youTubeListProvider.notifier).loadChannels();

      // ! Twitch streamers
      await ref.read(twitchListProvider.notifier).loadStreamers();
      await ref.read(twitchListProvider.notifier).refreshStreamers();

      return true;
    } catch (e) {
      debugPrint('Error initializing app settings: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _initAppSettings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(
                'Error: ${snapshot.error}',
                textAlign: TextAlign.justify,
              ),
            ),
          );
        }
        if (snapshot.hasData && snapshot.data == false) {
          return Scaffold(
            body: Center(
              child: Text('Error initializing app settings: ${snapshot.error}'),
            ),
          );
        }
        return const AppSkeleton();
      },
    );
  }

  // ************************************************************
  // ! Tray Manager
  // ************************************************************

  @override
  void onTrayIconMouseDown() async {
    await trayManager.popUpContextMenu();
  }

  @override
  void onTrayIconMouseUp() async {
    // do something
  }

  @override
  void onTrayIconRightMouseDown() async {
    await trayManager.popUpContextMenu();
  }

  @override
  void onTrayIconRightMouseUp() {
    // do something
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) async {
    // do something
  }

  // ************************************************************
  // ! Window Manager
  // ************************************************************

  @override
  void onWindowEvent(String eventName) {
    // print('[WindowManager] onWindowEvent: $eventName');
  }

  @override
  void onWindowClose() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Close Window'),
          content: const Text('Are you sure you want to close the window?'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                context.pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await windowManager.destroy();
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.red),
              ),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  void onWindowFocus() {
    // do something
  }

  @override
  void onWindowBlur() {
    // do something
  }

  @override
  void onWindowMaximize() {
    // do something
  }

  @override
  void onWindowUnmaximize() {
    // do something
  }

  @override
  void onWindowMinimize() {
    // do something
  }

  @override
  void onWindowRestore() {
    // do something
  }

  @override
  void onWindowResize() {
    // do something
  }

  @override
  void onWindowMove() {
    // do something
  }

  @override
  void onWindowEnterFullScreen() {
    // do something
  }

  @override
  void onWindowLeaveFullScreen() {
    // do something
  }
}

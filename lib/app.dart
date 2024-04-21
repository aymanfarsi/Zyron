import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' show Scaffold, CircularProgressIndicator;
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';
import 'package:zyron/providers/app_settings_provider.dart';
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
    final appSettings = ref.read(appSettingsProvider);

    try {
      // ! Always on top
      await windowManager.setAlwaysOnTop(appSettings.isAlwaysOnTop);

      // ! Prevent close
      await windowManager.setPreventClose(appSettings.isPreventClose);

      // ! Auto start
      if (appSettings.isAutoStart) {
        await launchAtStartup.enable();
      } else {
        await launchAtStartup.disable();
      }

      // ! App settings
      await ref.read(appSettingsProvider.notifier).loadSettings();

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _initAppSettings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return const AppSkeleton();
        }
        return Scaffold(
          body: Center(
            child: snapshot.hasError
                ? Text('Error: ${snapshot.error}')
                : const CircularProgressIndicator(),
          ),
        );
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
        return ContentDialog(
          title: const Text('Close Window'),
          content: const Text('Are you sure you want to close the window?'),
          actions: <Widget>[
            Button(
              onPressed: () {
                context.pop();
              },
              child: const Text('Cancel'),
            ),
            Button(
              onPressed: () async {
                await windowManager.destroy();
              },
              style: ButtonStyle(
                backgroundColor: ButtonState.all(Colors.red),
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
    setState(() {});
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

import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

class SkeletonApp extends StatefulWidget {
  const SkeletonApp({super.key});

  @override
  SkeletonAppState createState() => SkeletonAppState();
}

class SkeletonAppState extends State<SkeletonApp>
    with WindowListener, TrayListener {
  @override
  void initState() {
    trayManager.addListener(this);
    super.initState();
    windowManager.addListener(this);
  }

  @override
  void dispose() {
    trayManager.removeListener(this);
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const SkeletonApp();

  /**
   * ! Tray Manager
   */

  @override
  void onTrayIconMouseDown() async {
    // do something, for example pop up the menu
    await trayManager.popUpContextMenu();
  }

  @override
  void onTrayIconRightMouseDown() {
    // do something
  }

  @override
  void onTrayIconRightMouseUp() {
    // do something
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) async {
    if (menuItem.key == 'show_window') {
      await windowManager.show();
      await windowManager.focus();
    } else if (menuItem.key == 'exit_app') {
      await windowManager.close();
    }
  }

  /**
   * ! Window Manager
   */

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

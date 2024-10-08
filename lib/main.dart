import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';
import 'package:windows_taskbar/windows_taskbar.dart';
import 'package:zyron/apps/error_app.dart';
import 'package:zyron/providers/app_settings_provider.dart';
import 'package:zyron/src/rust/frb_generated.dart';
import 'package:zyron/src/variables.dart';

Future<void> main() async {
  // ! Ensure that Flutter and Rust are initialized
  WidgetsFlutterBinding.ensureInitialized();
  await RustLib.init();

  // ! Setup launch at startup
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  launchAtStartup.setup(
    appName: packageInfo.appName,
    appPath: Platform.resolvedExecutable,
  );

  // ! Initialize the system tray
  await trayManager.setIcon(
    Platform.isWindows ? 'assets/zyron_icon.ico' : 'assets/zyron_icon.png',
    iconPosition: TrayIconPositon.left,
  );
  if (Platform.isWindows) {
    await trayManager.setToolTip('Zyron System Tray');
  }
  Menu menu = Menu(
    items: [
      MenuItem(
        key: 'show',
        label: 'Show',
        onClick: (MenuItem item) async {
          await windowManager.show(inactive: false);
        },
      ),
      MenuItem(
        key: 'hide',
        label: 'Hide',
        onClick: (MenuItem item) async {
          await windowManager.hide();
        },
      ),
      MenuItem.separator(),
      MenuItem.submenu(
        label: 'Settings',
        submenu: Menu(
          items: [
            MenuItem.checkbox(
              key: 'always_on_top',
              label: 'Always on Top',
              checked: await windowManager.isAlwaysOnTop(),
              onClick: (MenuItem item) async {
                bool alwaysOnTop = await windowManager.isAlwaysOnTop();
                await windowManager.setAlwaysOnTop(!alwaysOnTop);
              },
            ),
            MenuItem.checkbox(
              key: 'prevent_close',
              label: 'Prevent Close',
              checked: await windowManager.isPreventClose(),
              onClick: (MenuItem item) async {
                bool preventClose = await windowManager.isPreventClose();
                await windowManager.setPreventClose(!preventClose);
              },
            ),
          ],
        ),
      ),
      MenuItem.separator(),
      MenuItem(
        key: 'exit',
        label: 'Exit',
        onClick: (MenuItem item) async {
          bool isVisible = await windowManager.isVisible();
          if (!isVisible) {
            await windowManager.show(inactive: false);
          }
          await windowManager.close();
        },
      ),
    ],
  );
  await trayManager.setContextMenu(menu);

  // ! Initialize the window manager
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    title: 'Zyron',
    size: Size(800, 600),
    minimumSize: Size(800, 600),
    center: true,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();

    // ! Initialize the Windows Taskbar
    if (Platform.isWindows) {
      try {
        await WindowsTaskbar.setThumbnailTooltip('Zyron');
        await WindowsTaskbar.resetThumbnailToolbar();
        await WindowsTaskbar.setThumbnailToolbar(
          [
            ThumbnailToolbarButton(
              ThumbnailToolbarAssetIcon('assets/zyron_icon.ico'),
              'App Icon',
              () async {
                debugPrint('ThumbnailToolbarButton clicked');
              },
              // mode: ThumbnailToolbarButtonMode.noBackground,
            ),
          ],
        );
      } catch (e) {
        if (!Platform.isWindows) {
          debugPrint('Unsupported taskbar for ${Platform.operatingSystem}');
        } else {
          debugPrint('Initialize the Windows Taskbar Error: $e');
        }
      }
    }
  });

  // ! Run the app
  switch (Platform.operatingSystem) {
    case 'windows':
    case 'linux':
      runApp(
        const ProviderScope(
          child: ZyronApp(),
        ),
      );
      break;
    default:
      runApp(
        ProviderScope(
          child: ErrorApp(
            message: 'Unsupported platform: ${Platform.operatingSystem}',
          ),
        ),
      );
  }
}

class ZyronApp extends ConsumerWidget {
  const ZyronApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appSettings = ref.watch(appSettingsProvider);

    return MaterialApp.router(
      title: 'Zyron',
      debugShowCheckedModeBanner: false,
      // theme: catppuccinTheme(catppuccin.latte),
      // darkTheme: catppuccinTheme(catppuccin.macchiato),
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: appSettings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      routerConfig: router,
      localizationsDelegates: const [
        DefaultMaterialLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      locale: const Locale('en', 'US'),
      supportedLocales: const [Locale('en', 'US')],
      onGenerateTitle: (context) => 'Zyron',
      scrollBehavior: const ScrollBehavior(),
      actions: <Type, Action<Intent>>{
        ...WidgetsApp.defaultActions,
        ActivateAction: CallbackAction(
          onInvoke: (Intent intent) {
            return null;
          },
        ),
      },
    );
  }
}

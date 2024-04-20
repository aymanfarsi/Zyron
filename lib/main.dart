import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:twitch_api/twitch_api.dart';
import 'package:window_manager/window_manager.dart';
import 'package:windows_taskbar/windows_taskbar.dart';
import 'package:zyron/src/rust/frb_generated.dart';
import 'package:zyron/src/utils.dart';
import 'package:zyron/src/variables.dart';

Future<void> main() async {
  // ! Ensure that Flutter and Rust are initialized
  WidgetsFlutterBinding.ensureInitialized();
  await RustLib.init();

  // ! Load environment variables
  await dotenv.load();
  twitchClientId = dotenv.env['TWITCH_CLIENT_ID']!;
  twitchClient = TwitchClient(
    clientId: twitchClientId,
    redirectUri: redirectUri,
  );

  // ! Register app links
  await register('zyron');
  final appLinks = AppLinks();
  appLinks.allUriLinkStream.listen((Uri uri) {
    debugPrint('Received uri: $uri');
    try {
      twitchClient.initializeToken(
        TwitchToken.fromUrl(uri.toString()),
      );
    } catch (e) {
      debugPrint('Register app links Error: $e');
    }
  });

  // ! Launch at startup
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  launchAtStartup.setup(
    appName: packageInfo.appName,
    appPath: Platform.resolvedExecutable,
  );
  await launchAtStartup.enable();

  // ! Initialize the system tray
  await trayManager.setIcon(
    // Platform.isWindows ? 'assets/zyron_icon.ico' : 'assets/zyron_icon.png',
    'assets/zyron_icon.ico',
    iconPosition: TrayIconPositon.left,
  );
  await trayManager.setToolTip('Zyron System Tray');
  Menu menu = Menu(
    items: [
      MenuItem(
        key: 'app_name',
        label: 'Zyron',
        disabled: true,
      ),
      MenuItem.separator(),
      MenuItem(
        key: 'exit',
        label: 'Exit',
        onClick: (MenuItem item) async {
          await windowManager.close();
        },
      ),
    ],
  );
  await trayManager.setContextMenu(menu);

  // ! Initialize the Windows Taskbar
  try {
    await WindowsTaskbar.resetThumbnailToolbar();
    await WindowsTaskbar.setThumbnailToolbar(
      [
        ThumbnailToolbarButton(
          ThumbnailToolbarAssetIcon('assets/zyron_icon.ico'),
          'App Icon',
          () async {
            debugPrint('ThumbnailToolbarButton clicked');
          },
          mode: ThumbnailToolbarButtonMode.noBackground,
        ),
      ],
    );
  } catch (e) {
    debugPrint('Initialize the Windows Taskbar Error: $e');
  }

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
    await windowManager.setAlwaysOnTop(false);
    await windowManager.setPreventClose(true);
    await windowManager.show();
    await windowManager.focus();
  });

  // ! Run the app
  runApp(
    FluentApp.router(
      title: 'Zyron',
      debugShowCheckedModeBanner: false,
      theme: FluentThemeData.light().copyWith(
        animationCurve: Curves.easeInOutCirc,
      ),
      darkTheme: FluentThemeData.dark().copyWith(
        animationCurve: Curves.easeInOutCirc,
      ),
      themeMode: ThemeMode.dark,
      routerConfig: router,
      localizationsDelegates: const [
        DefaultMaterialLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      locale: const Locale('en', 'US'),
      supportedLocales: const [Locale('en', 'US')],
      onGenerateTitle: (context) => 'Zyron',
      scrollBehavior: const FluentScrollBehavior(),
      actions: <Type, Action<Intent>>{
        ...WidgetsApp.defaultActions,
        ActivateAction: CallbackAction(
          onInvoke: (Intent intent) {
            return null;
          },
        ),
      },
    ),
  );
}

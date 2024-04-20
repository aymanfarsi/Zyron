import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:twitch_api/twitch_api.dart';
import 'package:window_manager/window_manager.dart';
import 'package:zyron/src/variables.dart';
import 'package:zyron/views/skeleton.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();
  twitchClientId = dotenv.env['TWITCH_CLIENT_ID']!;
  twitchClient = TwitchClient(
    clientId: twitchClientId,
    redirectUri: redirectUri,
  );

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

class SkeletonApp extends StatefulWidget {
  const SkeletonApp({super.key});

  @override
  SkeletonAppState createState() => SkeletonAppState();
}

class SkeletonAppState extends State<SkeletonApp> with WindowListener {
  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const AppSkeleton();
  }

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

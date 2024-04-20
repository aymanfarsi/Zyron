import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart' show DefaultCupertinoLocalizations;
import 'package:zyron/src/variables.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FluentApp.router(
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
        DefaultCupertinoLocalizations.delegate,
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
    );
  }
}

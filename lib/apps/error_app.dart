import 'package:catppuccin_flutter/catppuccin_flutter.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:zyron/providers/app_settings_provider.dart';
import 'package:zyron/src/utils.dart';

class ErrorApp extends ConsumerWidget {
  const ErrorApp({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appSettings = ref.watch(appSettingsProvider);

    return MaterialApp(
      title: 'Zyron',
      debugShowCheckedModeBanner: false,
      theme: catppuccinTheme(catppuccin.latte),
      darkTheme: catppuccinTheme(catppuccin.macchiato),
      themeMode: appSettings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      localizationsDelegates: const [
        DefaultMaterialLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      locale: const Locale('en', 'US'),
      supportedLocales: const [Locale('en', 'US')],
      onGenerateTitle: (context) => 'Zyron',
      scrollBehavior: const NavigationViewScrollBehavior(),
      actions: <Type, Action<Intent>>{
        ...WidgetsApp.defaultActions,
        ActivateAction: CallbackAction(
          onInvoke: (Intent intent) {
            return null;
          },
        ),
      },
      home: Scaffold(
        body: Center(
          child: Text(
            'Error: $message',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.justify,
          ),
        ),
      ),
    );
  }
}

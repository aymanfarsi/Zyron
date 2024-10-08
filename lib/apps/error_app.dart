import 'package:flutter/material.dart';
import 'package:catppuccin_flutter/catppuccin_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:zyron/src/utils.dart';

class ErrorApp extends ConsumerWidget {
  const ErrorApp({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Zyron',
      debugShowCheckedModeBanner: false,
      theme: catppuccinTheme(catppuccin.latte),
      darkTheme: catppuccinTheme(catppuccin.macchiato),
      themeMode: ThemeMode.dark,
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

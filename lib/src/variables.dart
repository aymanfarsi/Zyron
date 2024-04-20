import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:zyron/views/main_page.dart';

// ! Pages enums
enum AppPages {
  youtube,
  twitch;

  IconData get icon {
    switch (this) {
      case AppPages.youtube:
        return FontAwesomeIcons.youtube;
      case AppPages.twitch:
        return FontAwesomeIcons.twitch;
    }
  }

  static List<AppPages> get sidebarItems {
    return [
      AppPages.youtube,
      AppPages.twitch,
    ];
  }
}

// ! GoRouter configuration
final router = GoRouter(
  initialLocation: '/',
  observers: [
    NavigatorObserver(),
  ],
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const MainPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
            child: child,
          );
        },
      ),
    ),
  ],
);

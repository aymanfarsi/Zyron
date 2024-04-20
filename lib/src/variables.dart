import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:twitch_api/twitch_api.dart';
import 'package:zyron/app.dart';
import 'package:zyron/views/anime_view.dart';
import 'package:zyron/views/help_view.dart';
import 'package:zyron/views/settings_view.dart';
import 'package:zyron/views/twitch_view.dart';
import 'package:zyron/views/youtube_view.dart';

// ! Twitch API
late final String twitchClientId;
const String redirectUri = 'zyron://';
late final TwitchClient twitchClient;

// ! Pages enums
enum AppPages {
  youtube,
  twitch,
  anime,
  settings,
  help;

  IconData get icon {
    switch (this) {
      case AppPages.youtube:
        return FontAwesomeIcons.youtube;
      case AppPages.twitch:
        return FontAwesomeIcons.twitch;
      case AppPages.anime:
        return FontAwesomeIcons.dragon;
      case AppPages.settings:
        return FontAwesomeIcons.gear;
      case AppPages.help:
        return FontAwesomeIcons.circleQuestion;
    }
  }

  static List<AppPages> get sidebarItems {
    return [
      AppPages.youtube,
      AppPages.twitch,
      AppPages.anime,
    ];
  }

  static List<AppPages> get footerItems {
    return [
      AppPages.settings,
      AppPages.help,
    ];
  }

  Widget get widget {
    switch (this) {
      case AppPages.youtube:
        return const YouTubeView();
      case AppPages.twitch:
        return const TwitchView();
      case AppPages.anime:
        return const AnimeView();
      case AppPages.settings:
        return const SettingsView();
      case AppPages.help:
        return const HelpView();
    }
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
        child: const SkeletonApp(),
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

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:zyron/apps/app.dart';
import 'package:zyron/views/anime_view.dart';
import 'package:zyron/views/help_view.dart';
import 'package:zyron/views/settings_view.dart';
import 'package:zyron/views/twittch_page/twitch_view.dart';
import 'package:zyron/views/youtube_page/youtube_view.dart';

// ! Twitch API
// late final String twitchClientId;
// const String redirectUri = 'zyron://';
// late final TwitchClient twitchClient;

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

  int get idx {
    switch (this) {
      case AppPages.youtube:
        return 0;
      case AppPages.twitch:
        return 1;
      case AppPages.anime:
        return 2;
      case AppPages.settings:
        return 3;
      case AppPages.help:
        return 4;
    }
  }

  String get name {
    switch (this) {
      case AppPages.youtube:
        return 'YouTube';
      case AppPages.twitch:
        return 'Twitch';
      case AppPages.anime:
        return 'Anime';
      case AppPages.settings:
        return 'Settings';
      case AppPages.help:
        return 'Help';
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
        child: const AppFrame(),
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

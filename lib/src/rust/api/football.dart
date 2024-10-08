// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

// These function are ignored because they are on traits that is not defined in current crate (put an empty `#[frb]` on it to unignore): `fmt`, `fmt`

Future<List<Stage>> scrapeLiveScore() =>
    RustLib.instance.api.crateApiFootballScrapeLiveScore();

class Game {
  final String gameTime;
  final String homeTeam;
  final String awayTeam;
  final int homeScore;
  final int awayScore;
  final String matchClock;

  const Game({
    required this.gameTime,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeScore,
    required this.awayScore,
    required this.matchClock,
  });

  @override
  int get hashCode =>
      gameTime.hashCode ^
      homeTeam.hashCode ^
      awayTeam.hashCode ^
      homeScore.hashCode ^
      awayScore.hashCode ^
      matchClock.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Game &&
          runtimeType == other.runtimeType &&
          gameTime == other.gameTime &&
          homeTeam == other.homeTeam &&
          awayTeam == other.awayTeam &&
          homeScore == other.homeScore &&
          awayScore == other.awayScore &&
          matchClock == other.matchClock;
}

class Stage {
  final String name;
  final String event;
  final List<Game> games;

  const Stage({
    required this.name,
    required this.event,
    required this.games,
  });

  @override
  int get hashCode => name.hashCode ^ event.hashCode ^ games.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Stage &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          event == other.event &&
          games == other.games;
}

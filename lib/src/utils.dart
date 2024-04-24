import 'dart:io';

import 'package:win32_registry/win32_registry.dart';
import 'package:zyron/models/player_settings_model.dart';
import 'package:zyron/models/twitch_streamer_model.dart';
import 'package:zyron/models/youtube_video_model.dart';

Future<void> watchStream(
  TwitchStreamerModel streamer,
  PlayerSettingsModel player,
) async {
  await Process.run(player.mpvExe, [
    '--no-terminal',
    if (player.exitOnDone) '--keep-open=yes',
    player.quality.isNotEmpty
        ? '--ytdl-format=${player.quality}'
        : '--ytdl-format=bestvideo[height<=?1080]+bestaudio/best',
    '--volume=${player.volume}',
    '--title=Ryzon: ${streamer.displayName}',
    '--autofit=50%:50%',
    '--geometry=50%:50%',
    // '--force-window',
    // '--ontop',
    // '--no-border',
    // '--no-input-default-bindings',
    // '--input-ipc-server=${player.mpvSocket}',
    'https://www.twitch.tv/${streamer.username}',
  ]);
}

Future<void> watchVideo(
  YouTubeVideoModel video,
  PlayerSettingsModel player,
) async {
  await Process.run(player.mpvExe, [
    '--no-terminal',
    '--pause=${player.isAutoPlay ? 'no' : 'yes'}',
    if (player.exitOnDone) '--keep-open=yes',
    player.quality.isNotEmpty
        ? '--ytdl-format=${player.quality}'
        : '--ytdl-format=bestvideo[height<=?1080]+bestaudio/best',
    '--volume=${player.volume}',
    '--title=Ryzon: ${video.title}',
    '--autofit=50%:50%',
    '--geometry=50%:50%',
    // '--force-window',
    // '--ontop',
    // '--no-border',
    // '--no-input-default-bindings',
    // '--input-ipc-server=${player.mpvSocket}',
    video.url,
  ]);
}

String formatPublishedDate(DateTime? publishedDate) {
  if (publishedDate == null) {
    return 'Unknown';
  }
  final now = DateTime.now();
  final difference = now.difference(publishedDate);
  if (difference.inDays > 365) {
    return '${publishedDate.year}';
  } else if (difference.inDays > 30) {
    return '${publishedDate.month}/${publishedDate.year}';
  } else if (difference.inDays > 0) {
    return '${publishedDate.day}/${publishedDate.month.toString().padLeft(2, '0')}';
  } else if (difference.inHours > 0) {
    return '${publishedDate.hour}:${publishedDate.minute}';
  } else {
    return '${difference.inMinutes}m';
  }
}

String formatDuration(Duration? duration) {
  if (duration == null) {
    return 'Unknown';
  }
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  String formattedDuration = '';
  if (duration.inHours > 0) {
    formattedDuration = '${twoDigits(duration.inHours)}:';
  }
  return '$formattedDuration$twoDigitMinutes:$twoDigitSeconds';
}

String formatSubscribers(int subscribers) {
  if (subscribers == -1) {
    return 'Unknown';
  } else if (subscribers < 1000) {
    return '$subscribers';
  } else if (subscribers < 1000000) {
    return '${(subscribers / 1000).toStringAsFixed(1)}K';
  } else if (subscribers < 1000000000) {
    return '${(subscribers / 1000000).toStringAsFixed(1)}M';
  } else {
    return '${(subscribers / 1000000000).toStringAsFixed(1)}B';
  }
}

Future<void> register(String scheme) async {
  String appPath = Platform.resolvedExecutable;

  String protocolRegKey = 'Software\\Classes\\$scheme';
  RegistryValue protocolRegValue = const RegistryValue(
    'URL Protocol',
    RegistryValueType.string,
    '',
  );
  String protocolCmdRegKey = 'shell\\open\\command';
  RegistryValue protocolCmdRegValue = RegistryValue(
    '',
    RegistryValueType.string,
    '"$appPath" "%1"',
  );

  final regKey = Registry.currentUser.createKey(protocolRegKey);
  regKey.createValue(protocolRegValue);
  regKey.createKey(protocolCmdRegKey).createValue(protocolCmdRegValue);
}

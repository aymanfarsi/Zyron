import 'dart:io';

import 'package:win32_registry/win32_registry.dart';

String formatDuration(Duration? duration) {
  if (duration == null) {
    return 'Unknown';
  }
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
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

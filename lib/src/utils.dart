import 'dart:io';

import 'package:win32_registry/win32_registry.dart';

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

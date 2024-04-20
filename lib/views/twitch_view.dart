import 'package:flutter/material.dart';

class TwitchView extends StatefulWidget {
  const TwitchView({super.key});

  @override
  State<TwitchView> createState() => _TwitchViewState();
}

class _TwitchViewState extends State<TwitchView> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Twitch View'),
    );
  }
}

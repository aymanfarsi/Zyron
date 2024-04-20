import 'package:flutter/material.dart';

class YouTubeView extends StatefulWidget {
  const YouTubeView({super.key});

  @override
  State<YouTubeView> createState() => _YouTubeViewState();
}

class _YouTubeViewState extends State<YouTubeView> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('YouTube View'),
    );
  }
}

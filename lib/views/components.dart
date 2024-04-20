import 'package:flutter/material.dart';

class AppIconButton extends StatelessWidget {
  final Widget icon;
  final Function() onPressed;
  const AppIconButton({super.key, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: icon,
        style: const ButtonStyle(
          splashFactory: NoSplash.splashFactory,
        ),
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        onPressed: onPressed);
  }
}

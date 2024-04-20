import 'package:flutter/material.dart';

// ! AppIconButton
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

// ! Box Decoration - border wrapping
final boxDecoration = BoxDecoration(
  border: Border.all(
    color: Colors.white,
    width: 0.3,
  ),
  borderRadius: BorderRadius.circular(12.0),
);

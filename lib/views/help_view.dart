import 'package:flutter/material.dart';
import 'package:zyron/src/rust/api/simple.dart';

class HelpView extends StatelessWidget {
  const HelpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            greet(name: 'Zyron'),
            style: const TextStyle(
              fontSize: 24.0,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:zyron/views/components.dart';

class TwitchView extends StatefulWidget {
  const TwitchView({super.key});

  @override
  State<TwitchView> createState() => _TwitchViewState();
}

class _TwitchViewState extends State<TwitchView> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 150.0,
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              scrollbars: false,
              physics: const BouncingScrollPhysics(),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 10,
              itemBuilder: (context, index) {
                return const Card(
                  child: ListTile(
                    title: Text('Twitch Channel'),
                    subtitle: Text('Online'),
                    leading: Icon(Icons.circle),
                  ),
                );
              },
            ),
          ),
        ),
        const Gap(9.0),
        Container(
          width: MediaQuery.of(context).size.width - 236.0,
          decoration: boxDecoration,
          child: const Center(
            child: Text('Twitch'),
          ),
        )
      ],
    );
  }
}

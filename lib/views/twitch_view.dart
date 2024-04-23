import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:zyron/views/components.dart';

class TwitchView extends StatefulWidget {
  const TwitchView({super.key});

  @override
  State<TwitchView> createState() => _TwitchViewState();
}

class _TwitchViewState extends State<TwitchView> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 175.0,
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              scrollbars: false,
              physics: const BouncingScrollPhysics(),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 10,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 2.0,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  color: selectedIndex == index
                      ? Colors.grey[200]
                      : Colors.transparent,
                  child: Tooltip(
                    richMessage: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Twitch Channel ',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.8),
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: '${index + 1}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                    waitDuration: const Duration(milliseconds: 1000),
                    preferBelow: true,
                    child: ListTile(
                      visualDensity: VisualDensity.compact,
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      selected: selectedIndex == index,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 8.0),
                      title: const Text(
                        'Twitch Channel',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      subtitle: const Text(
                        'Online',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 10.0,
                        ),
                      ),
                      leading: const CircleAvatar(
                        backgroundColor: Colors.purple,
                        child: Icon(
                          Icons.circle,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const Gap(9.0),
        Container(
          width: MediaQuery.of(context).size.width - 261.0,
          decoration: boxDecoration,
          child: Center(
            child: Text('Twitch Channel ${selectedIndex + 1}'),
          ),
        )
      ],
    );
  }
}

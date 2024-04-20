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
                return Card(
                  elevation: 2.0,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  child: Tooltip(
                    message: 'Twitch Channel',
                    waitDuration: const Duration(milliseconds: 1000),
                    preferBelow: true,
                    child: ListTile(
                      visualDensity: VisualDensity.compact,
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      selected: selectedIndex == index,
                      selectedColor: Colors.yellow,
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
          width: MediaQuery.of(context).size.width - 236.0,
          decoration: boxDecoration,
          child: Center(
            child: Text('Twitch Channel ${selectedIndex + 1}'),
          ),
        )
      ],
    );
  }
}

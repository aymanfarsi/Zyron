import 'package:flutter/material.dart' hide ButtonStyle;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:zyron/providers/youtube_provider.dart';
import 'package:zyron/src/utils.dart';
import 'package:zyron/views/components.dart';

class ListChannels extends HookConsumerWidget {
  const ListChannels({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ytList = ref.watch(youTubeListProvider);
    final selectedIndex = useState(0);
    final selectedVideo = useState(0);

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
              shrinkWrap: false,
              itemCount: ytList.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return MouseRegion(
                  cursor: SystemMouseCursors.basic,
                  child: Card(
                    elevation: 2.0,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    color: selectedIndex.value == index
                        ? Colors.amber.withOpacity(0.2)
                        : Colors.transparent,
                    child: ListTile(
                      visualDensity: VisualDensity.compact,
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      selected: selectedIndex.value == index,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 8.0),
                      title: Text(
                        ytList[index].name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      subtitle: Text(
                        formatSubscribers(ytList[index].subscribers),
                        style: const TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          ytList[index].logo,
                        ),
                      ),
                      onTap: () {
                        selectedIndex.value = index;
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const Gap(9.0),
        SizedBox(
          width: MediaQuery.of(context).size.width - 261.0,
          height: MediaQuery.of(context).size.height - 129.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height -
                    (selectedVideo.value == 0 ? 129.0 : 289.0),
                padding: const EdgeInsets.all(8.0),
                decoration: boxDecoration,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).size.width ~/ 200,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 2.5,
                  ),
                  shrinkWrap: false,
                  itemCount: ytList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 2.0,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      child: ListTile(
                        title: Text(
                          ytList[index].name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        subtitle: Text(
                          formatSubscribers(ytList[index].subscribers),
                          style: const TextStyle(
                            fontSize: 12.0,
                          ),
                        ),
                        leading: CircleAvatar(
                          radius: 15.0,
                          backgroundImage: NetworkImage(
                            ytList[index].logo,
                          ),
                        ),
                        onTap: () => selectedVideo.value = index,
                      ),
                    );
                  },
                ),
              ),
              Visibility(
                visible: selectedVideo.value != 0,
                child: const Gap(9.0),
              ),
              Visibility(
                visible: selectedVideo.value != 0,
                child: Container(
                  height: 151.0,
                  padding: const EdgeInsets.all(8.0),
                  decoration: boxDecoration,
                  child: Center(
                    child: Text('video ${selectedVideo.value}'),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

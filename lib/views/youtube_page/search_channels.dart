import 'package:desktop_context_menu/desktop_context_menu.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:zyron/providers/youtube_provider.dart';
import 'package:zyron/src/utils.dart';
import 'package:zyron/views/components.dart';
import 'package:zyron/views/youtube_page/youtube_view.dart';

class SearchChannel extends HookConsumerWidget {
  const SearchChannel({super.key});

  

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewType = useState(YouTubeViewType.start);

    final searchList = useState([]);
    final searchQuery = useTextEditingController();

    return Container(
      decoration: boxDecoration,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.all(9.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 40.0,
                width: 500.0,
                child: TextBox(
                  controller: searchQuery,
                  placeholder: 'Search YouTube',
                  decoration: boxDecoration.copyWith(
                    border: const Border.symmetric(
                      horizontal: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (value) async {
                    searchList.value = [];
                    viewType.value = YouTubeViewType.searching;
                    searchList.value = await ref
                        .read(youTubeListProvider.notifier)
                        .search(query: searchQuery.text);
                    viewType.value = YouTubeViewType.results;
                  },
                ),
              ),
              const Gap(20.0),
              IconButton(
                icon: const Icon(FluentIcons.search),
                iconButtonMode: IconButtonMode.small,
                onPressed: () async {
                  searchList.value = [];
                  viewType.value = YouTubeViewType.searching;
                  searchList.value = await ref
                      .read(youTubeListProvider.notifier)
                      .search(query: searchQuery.text);
                  viewType.value = YouTubeViewType.results;
                },
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height - 174.1,
            width: MediaQuery.of(context).size.width,
            child: searchList.value.isEmpty
                ? Center(
                    child: Text(
                      viewType.value.message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: searchList.value.length,
                    itemBuilder: (context, index) {
                      final channel = searchList.value[index];
                      return GestureDetector(
                        onSecondaryTap: () async {
                          final item = await showContextMenu(
                            menuItems: [
                              ContextMenuItem(
                                title: 'Add to list',
                                onTap: () {},
                              ),
                              const ContextMenuSeparator(),
                              ContextMenuItem(
                                title: 'Cancel',
                                onTap: () {},
                              ),
                            ],
                          );
                          if (item == null) {
                            return;
                          }
                          await ref
                              .read(youTubeListProvider.notifier)
                              .addChannel(channel);
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: channel.logo.isEmpty
                                ? null
                                : NetworkImage(channel.logo),
                            backgroundColor: Colors.transparent,
                          ),
                          title: Text(channel.name),
                          subtitle: Text(
                            formatSubscribers(channel.subscribers),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:window_manager/window_manager.dart';
import 'package:zyron/providers/app_settings_provider.dart';
import 'package:zyron/src/variables.dart';
import 'package:zyron/views/components.dart';

class AppSkeleton extends StatefulHookConsumerWidget {
  const AppSkeleton({super.key});

  @override
  ConsumerState<AppSkeleton> createState() => _AppSkeletonState();
}

class _AppSkeletonState extends ConsumerState<AppSkeleton> {
  final contextAttachKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appSettings = ref.watch(appSettingsProvider);
    final pageIndex = useState(appSettings.startingPage);

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: Container(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              padding: const EdgeInsets.all(9.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  // ! App bar
                  Container(
                    height: 50.0,
                    width: constraints.maxWidth,
                    decoration: boxDecoration,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(9.0),
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 16.0,
                            child: Image.asset(
                              'assets/zyron_icon.ico',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: constraints.maxWidth - 189.0,
                          height: 50.0,
                          child: Stack(
                            children: [
                              const Center(
                                child: Text(
                                  'Zyron',
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                // ! Double tap to maximize
                                onDoubleTap: () async {
                                  if (await windowManager.isMaximized()) {
                                    await windowManager.restore();
                                  } else {
                                    await windowManager.maximize();
                                  }
                                },
                                // ! Drag to move
                                onPanStart: (details) async {
                                  await windowManager.startDragging();
                                },
                                child: Container(
                                  height: 50.0,
                                  width: constraints.maxWidth - 190.0,
                                  color: Colors.transparent,
                                ),
                              ),
                            ],
                          ),
                        ),
                        AppIconButton(
                          icon: const Icon(Icons.minimize),
                          onPressed: () async {
                            await windowManager.minimize();
                          },
                        ),
                        AppIconButton(
                          icon: const Icon(Icons.crop_square),
                          onPressed: () async {
                            if (await windowManager.isMaximized()) {
                              await windowManager.restore();
                            } else {
                              await windowManager.maximize();
                            }
                          },
                        ),
                        AppIconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () async {
                            await windowManager.close();
                          },
                        ),
                      ],
                    ),
                  ),

                  const Gap(9.0),

                  // ! Sidebar and main content
                  SizedBox(
                    height: constraints.maxHeight - 77.0,
                    width: constraints.maxWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        // ! Sidebar
                        Container(
                          height: constraints.maxHeight - 50.0,
                          width: 50.0,
                          decoration: boxDecoration,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              // ! Sidebar items
                              for (AppPages page in AppPages.sidebarItems)
                                SizedBox(
                                  height: 50.0,
                                  width: 50.0,
                                  child: AppIconButton(
                                    icon: FaIcon(page.icon),
                                    onPressed: () {
                                      pageIndex.value =
                                          AppPages.sidebarItems.indexOf(page);
                                    },
                                  ),
                                ),
                              const Spacer(),
                              // ! Sidebar footer
                              for (AppPages page in AppPages.footerItems)
                                SizedBox(
                                  height: 50.0,
                                  width: 50.0,
                                  child: AppIconButton(
                                    icon: FaIcon(page.icon),
                                    onPressed: () {
                                      pageIndex.value =
                                          AppPages.footerItems.indexOf(page) +
                                              4;
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ),

                        const Gap(9.0),

                        // ! Main content
                        SizedBox(
                          height: constraints.maxHeight - 50.0,
                          width: MediaQuery.of(context).size.width - 77,
                          child: IndexedStack(
                            index: pageIndex.value,
                            children: <Widget>[
                              for (AppPages page in AppPages.values)
                                SizedBox(
                                  height: constraints.maxHeight - 50.0,
                                  width: MediaQuery.of(context).size.width - 77,
                                  child: page.widget,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

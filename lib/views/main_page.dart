import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:window_manager/window_manager.dart';
import 'package:zyron/src/variables.dart';
import 'package:zyron/views/components.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int pageIndex = 0;

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
    debugPrint('Building MainPage');
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
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey[300] ?? Colors.grey,
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(9.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(9.0),
                          child: GestureDetector(
                            onTap: () async {
                              if (await windowManager.isAlwaysOnTop()) {
                                await windowManager.setAlwaysOnTop(false);
                              } else {
                                await windowManager.setAlwaysOnTop(true);
                              }
                              debugPrint(
                                  'Always on top is set to ${await windowManager.isAlwaysOnTop()}');
                            },
                            child: Container(
                              height: 32.0,
                              width: 50.0,
                              decoration: BoxDecoration(
                                color: Colors.yellow,
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: constraints.maxWidth - 210.0,
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
                                onDoubleTap: () async {
                                  if (await windowManager.isMaximized()) {
                                    await windowManager.restore();
                                  } else {
                                    await windowManager.maximize();
                                  }
                                },
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
                          decoration: BoxDecoration(
                            // color: Colors.grey[200],
                            border: Border.all(
                              color: Colors.grey[300] ?? Colors.grey,
                              width: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              // ! Sidebar items
                              for (AppPages page in AppPages.sidebarItems)
                                SizedBox(
                                  height: 50.0,
                                  width: 50.0,
                                  child: AppIconButton(
                                    icon: FaIcon(
                                      page.icon,
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        pageIndex =
                                            AppPages.sidebarItems.indexOf(page);
                                      });
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const Gap(9.0),
                        // ! Main content
                        Container(
                          height: constraints.maxHeight - 50.0,
                          width: MediaQuery.of(context).size.width - 77,
                          padding: const EdgeInsets.all(9.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey[300] ?? Colors.grey,
                              width: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: IndexedStack(
                            index: pageIndex,
                            children: <Widget>[
                              for (AppPages page in AppPages.sidebarItems)
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

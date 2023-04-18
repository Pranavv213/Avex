import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_project/core/router.gr.dart';

import '../../util/show_dialog.dart';

class MainPageHostScreen extends StatelessWidget {
  MainPageHostScreen({super.key});
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  List<String> titles = ["Search", "Messages", "", "Portfolio", "Settings"];
  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
        homeIndex: 2,
        drawer: Drawer(
            elevation: 4,
            child: ListView(
              children: [
                ListTile(
                  // leading: Icon(Icons.message),
                  title: Text('Messages'),
                ),
                ListTile(
                  // leading: Icon(Icons.account_circle),
                  title: Text('Profile'),
                ),
                ListTile(
                  // leading: Icon(Icons.settings),
                  title: Text('Settings'),
                ),
              ],
            )),
        appBarBuilder: ((context, tabsRouter) {
          return AppBar(
            backgroundColor: Colors.transparent,
            leading: SizedBox(
              height: 34,
              width: 34,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: InkWell(
                  onTap: () {},
                  child: ClipOval(
                      child: CachedNetworkImage(
                    imageUrl:
                        "https://avatars.githubusercontent.com/u/64317542?v=4",
                  )),
                ),
              ),
            ),
            actions: [
              if (tabsRouter.activeIndex == 2)
                GestureDetector(
                  onTap: () {},
                  child: Image.asset("assets/qr_code.png"),
                ),
            ],
            title: (tabsRouter.activeIndex == 2)
                ? GestureDetector(
                    onTap: () => makeTranslucentDialog(context),
                    child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.white30,
                            borderRadius: BorderRadius.all(
                              Radius.circular(40.0),
                            )),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Etherium MainNet",
                                  style: GoogleFonts.urbanist(fontSize: 14)),
                              Icon(Icons.expand_more)
                            ],
                          ),
                        )),
                  )
                : Text(titles[tabsRouter.activeIndex]),
            elevation: 0,
            centerTitle: true,
          );
        }),
        routes: [
          const SearchRoute(),
          MessageRoute(),
          const HomeRoute(),
          const PortfolioRoute(),
          const SettingsRoute()
        ],
        bottomNavigationBuilder: (context, tabsRouter) => BottomNavigationBar(
              onTap: (index) {
                tabsRouter.setActiveIndex(index);
              },
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white30,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              backgroundColor: Colors.transparent,
              type: BottomNavigationBarType.fixed,
              currentIndex: tabsRouter.activeIndex,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(Icons.search), label: "Search"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.message), label: "Message"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.wallet), label: "Home"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.notifications_none),
                    label: "Notification"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.settings), label: "Settings"),
              ],
            ));
  }
}

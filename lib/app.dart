import 'package:flutter/material.dart';
import 'package:forward/repositories/auth_repository.dart';
import 'package:forward/widgets/bottom_navigation.dart';
import 'package:forward/widgets/tab_navigator_area.dart';
import 'package:forward/widgets/tab_navigator_feed.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AppState();
}

class AppState extends State<App> {
  TabItem currentTab = TabItem.feed;
  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.feed: GlobalKey<NavigatorState>(),
    TabItem.myArea: GlobalKey<NavigatorState>(),
    TabItem.profile: GlobalKey<NavigatorState>(),
  };

  void _selectTab(TabItem tabItem) {
    setState(() {
      currentTab = tabItem;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKeys[currentTab].currentState.maybePop(),
      child: Scaffold(
        /*appBar: new AppBar(
          actions: <Widget>[
            // action button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.center,
                child: GestureDetector(
                    onTap: () {
                      Provider.of<AuthRepository>(context).signOut();
                    },
                    child: Text('Log Out',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16))),
              ),
            ),
          ],
          // Set the background color of the App Bar
          // backgroundColor: Colors.blue,
        ),*/
        body: Stack(children: <Widget>[
          _buildOffstageNavigator(TabItem.feed),
          _buildOffstageNavigator(TabItem.myArea),
          _buildOffstageNavigator(TabItem.profile),
        ]),
        bottomNavigationBar: BottomNavigation(
          currentTab: currentTab,
          onSelectTab: _selectTab,
        ),
      ),
    );
  }

  Widget _buildOffstageNavigator(TabItem tabItem) {
    switch (tabItem) {
      case TabItem.feed:
        return Offstage(
          offstage: currentTab != tabItem,
          child: TabNavigatorFeed(
            navigatorKey: navigatorKeys[tabItem],
            tabItem: tabItem,
          ),
        );
        break;
      case TabItem.myArea:
        return Offstage(
          offstage: currentTab != tabItem,
          child: TabNavigatorMyArea(
            navigatorKey: navigatorKeys[tabItem],
            tabItem: tabItem,
          ),
        );
        break;
      default:
        return Offstage(
            offstage: currentTab != tabItem,
            child: TabNavigatorFeed(
              navigatorKey: navigatorKeys[tabItem],
              tabItem: tabItem,
            ));
    }
  }
}

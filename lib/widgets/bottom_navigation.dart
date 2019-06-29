import 'package:flutter/material.dart';

enum TabItem { feed, myArea, profile }

class TabHelper {
  static TabItem item({int index}) {
    switch (index) {
      case 0:
        return TabItem.feed;
      case 1:
        return TabItem.myArea;
      case 2:
        return TabItem.profile;
      default:
        return TabItem.feed;
    }
  }

  static String description(TabItem tabItem) {
    switch (tabItem) {
      case TabItem.feed:
        return 'feed';
      case TabItem.myArea:
        return 'my area';
      case TabItem.profile:
        return 'profile';
      default:
        return '';
    }
  }

  static IconData icon(TabItem tabItem) {
    switch (tabItem) {
      case TabItem.feed:
        return Icons.view_headline;
      case TabItem.myArea:
        return Icons.table_chart;
      case TabItem.profile:
        return Icons.person;
      default:
        return Icons.layers;
    }
  }

  /* static MaterialColor color(TabItem tabItem) {
    switch (tabItem) {
      case TabItem.red:
        return Colors.red;
      case TabItem.green:
        return Colors.green;
      case TabItem.blue:
        return Colors.blue;
    }
    return Colors.grey;
  } */
}

class BottomNavigation extends StatelessWidget {
  BottomNavigation({this.currentTab, this.onSelectTab});
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        _buildItem(tabItem: TabItem.feed),
        _buildItem(tabItem: TabItem.myArea),
        _buildItem(tabItem: TabItem.profile),
      ],
      onTap: (index) => onSelectTab(
            TabHelper.item(index: index),
          ),
    );
  }

  /* Color _colorTabMatching({TabItem item}) {
    return currentTab == item ? TabHelper.color(item) : Colors.grey;
  } */

  BottomNavigationBarItem _buildItem({TabItem tabItem}) {
    String text = TabHelper.description(tabItem);
    IconData icon = TabHelper.icon(tabItem);

    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        // color: _colorTabMatching(item: tabItem),
      ),
      title: Text(
        text,
        /* style: TextStyle(
          color: _colorTabMatching(item: tabItem),
        ), */
      ),
    );
  }
}

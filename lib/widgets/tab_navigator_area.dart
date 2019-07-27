import 'package:flutter/material.dart';
import 'package:forward/router.dart';
import 'package:forward/widgets/bottom_navigation.dart';

class TabNavigatorMyArea extends StatelessWidget {
  TabNavigatorMyArea({this.navigatorKey, this.tabItem});
  final GlobalKey<NavigatorState> navigatorKey;
  final TabItem tabItem;

  @override
  Widget build(BuildContext context) {
    return Navigator(
        key: navigatorKey,
        initialRoute: '/',
        onGenerateRoute: Router.generateRouteMyArea,
        onUnknownRoute: (settings) => MaterialPageRoute(
              builder: (_) => Scaffold(
                    body: Center(
                      child: Text('No route defined for ${settings.name}'),
                    ),
                  ),
            ));
  }
}

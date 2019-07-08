import 'package:flutter/material.dart';
import 'package:forward/models/activity_model.dart';
import 'package:forward/pages/feed_page.dart';
import 'package:forward/pages/login_page.dart';
import 'package:forward/pages/sign_up_page.dart';
import 'package:forward/pages/sms_code_page.dart';
import 'package:forward/pages/splash_page.dart';
import 'package:forward/repositories/activity_repository.dart';
import 'package:provider/provider.dart';

class Router {
  static Route<dynamic> generateRouteLogister(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case '/smsCode':
        SMSCodePageArguments args = settings.arguments;

        return MaterialPageRoute(
          builder: (_) => Provider<SMSCodePageArguments>.value(
                value: args,
                child: SMSCodePage(),
              ),
        );
      case '/signup':
        return MaterialPageRoute(builder: (_) => SignUpPage());
      default:
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          );
        });
    }
  }

  static Route<dynamic> generateRouteFeed(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => StreamProvider<List<Activity>>.value(
                stream: ActivityRepository.streamActivities(),
                child: FeedPage()
              ),
        );
      case '/activity':
        return MaterialPageRoute(builder: (_) => SplashPage());
      default:
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          );
        });
    }
  }
}

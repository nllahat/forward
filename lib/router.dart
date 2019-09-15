import 'package:flutter/material.dart';
import 'package:forward/core/models/activity_model.dart';
import 'package:forward/core/models/user_activity_model.dart';
import 'package:forward/pages/activity_page.dart';
import 'package:forward/pages/feed_page.dart';
import 'package:forward/pages/login_page.dart';
import 'package:forward/pages/my_area_page.dart';
import 'package:forward/pages/sign_up_page.dart';
import 'package:forward/pages/sms_code_page.dart';
import 'package:forward/repositories/activity_repository.dart';
import 'package:forward/repositories/auth_repository.dart';
import 'package:forward/repositories/user_activity_repository.dart';
import 'package:forward/utils/location_util.dart';
import 'package:geocoder/geocoder.dart';
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

  static Route<Widget> generateRouteFeed(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        /* return MaterialPageRoute(
          builder: (_) => StreamProvider<List<Activity>>.value(
            value: ActivityRepository.streamActivities(),
            child: FeedPage(),
          ),
        ); */
        return MaterialPageRoute(
            builder: (_) => MultiProvider(
                  providers: [
                    StreamProvider<List<Activity>>.value(
                        value: ActivityRepository.streamActivities()),
                    StreamProvider<Map<String, UserActivity>>.value(
                        value: UserActivityRepository.streamUserActivitesMap(
                            Provider.of<AuthRepository>(_).appUser.user.id)),
                  ],
                  child: FeedPage(),
                ));
      case '/activity':
        Activity args = settings.arguments;

        return MaterialPageRoute(
            builder: (_) => Provider<Activity>.value(
                  value: args,
                  child: FutureProvider<Address>.value(
                    value: LocationUtil.getAddressByGeoPoint(args.location),
                    catchError: (context, object) {
                      return Address();
                    },
                    child: ActivityPage(),
                  ),
                ));
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

  static Route<dynamic> generateRouteMyArea(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => StreamProvider<List<Activity>>.value(
            value: ActivityRepository.streamActivities(),
            child: MyAreaPage(),
          ),
        );
      case '/activity':
        Activity args = settings.arguments;

        return MaterialPageRoute(
            builder: (_) => Provider<Activity>.value(
                  value: args,
                  child: FutureProvider<Address>.value(
                    value: LocationUtil.getAddressByGeoPoint(args.location),
                    catchError: (context, object) {
                      return Address();
                    },
                    child: ActivityPage(),
                  ),
                ));
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

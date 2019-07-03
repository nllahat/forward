import 'package:flutter/material.dart';
import 'package:forward/pages/sign_up_page.dart';
import 'package:forward/repositories/auth_repository.dart';
import 'package:forward/app.dart';
import 'package:provider/provider.dart';
import 'package:forward/router.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  Widget _getPageByAuthState(AuthRepository userRepo) {
    switch (userRepo.status) {
      case Status.Uninitialized:
      case Status.Unauthenticated:
      case Status.NoUser:
        return SignUpPage();
      case Status.Authenticated:
        return App();
      default:
        return SignUpPage();
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        builder: (_) => AuthRepository.instance(),
        child: MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.grey,
          ),
          routes: {
            '/': (context) =>
                _getPageByAuthState(Provider.of<AuthRepository>(context)),
          },
          onGenerateRoute: Router.generateRoute,
          onUnknownRoute: (settings) => MaterialPageRoute(
                builder: (_) => Scaffold(
                      body: Center(
                        child: Text('No route defined for ${settings.name}'),
                      ),
                    ),
              ),
        ));
  }
}

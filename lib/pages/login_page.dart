import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forward/models/user_model.dart';
import 'package:forward/repositories/auth_repository.dart';
import 'package:forward/repositories/user_repository.dart';
import 'package:forward/utils/validator.dart';
import 'package:forward/widgets/loading.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _password = new TextEditingController();

  bool _autoValidate = false;
  bool _loadingVisible = false;
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    final authRepository = Provider.of<AuthRepository>(context);

    final logo = Hero(
        tag: 'hero',
        child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 60.0,
            child: Icon(
              Icons.person,
              size: 100.0,
              color: Colors.pink,
            )));

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      controller: _email,
      validator: Validator.validateEmail,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.email,
            color: Colors.grey,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          _login(context: context);
        },
        padding: EdgeInsets.all(12),
        color: Theme.of(context).primaryColor,
        child: Text('SIGN IN WITH GOOGLE', style: TextStyle(color: Colors.white)),
      ),
    );

    final forgotLabel = FlatButton(
      child: Text(
        'Forgot password?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {
        Navigator.pushNamed(context, '/forgot-password');
      },
    );

    final signUpLabel = FlatButton(
      child: Text(
        'Create an Account',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {
        Navigator.pushNamed(context, '/signup');
      },
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: LoadingScreen(
          child: Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      logo,
                      SizedBox(height: 48.0),
                      // email,
                      // SizedBox(height: 12.0),
                      loginButton,
                      // forgotLabel,
                      signUpLabel
                    ],
                  ),
                ),
              ),
            ),
          ),
          inAsyncCall: _loadingVisible),
    );
  }

  Future<void> _changeLoadingVisible() async {
    setState(() {
      _loadingVisible = !_loadingVisible;
    });
  }

  void _login({BuildContext context}) async {
    final authRepository = Provider.of<AuthRepository>(context);

    try {
      await _changeLoadingVisible();
      bool result = await authRepository.signInWithGoogle();

      if (result == true) {
        if (!await UserRepository.checkUserExist(
            authRepository.appUser.firebaseUser.uid)) {
          authRepository.waitingForSignUp();
        }
      }
    } catch (e) {
      _changeLoadingVisible();
      print("Sign In Error: $e");
    }
  }
}

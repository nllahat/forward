import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forward/repositories/auth_repository.dart';
import 'package:forward/utils/validator.dart';
import 'package:forward/widgets/loading.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phone = new TextEditingController();

  bool _autoValidate = false;
  bool _loadingVisible = false;

  String verificationId;
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
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

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          _login(context: context, phoneNumber: _phone.text);
        },
        padding: EdgeInsets.all(12),
        color: Theme.of(context).primaryColor,
        child: Text('SIGN IN WITH PHONE NUMBER',
            style: TextStyle(color: Colors.white)),
      ),
    );

    final phoneNumber = TextFormField(
      keyboardType: TextInputType.phone,
      autofocus: false,
      controller: _phone,
      validator: Validator.validatePhoneNumber,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.phone,
            color: Colors.grey,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: 'Phone Number',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
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
                      phoneNumber,
                      SizedBox(height: 12.0),
                      loginButton,
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

  void _login({String phoneNumber, BuildContext context}) async {
    final authRepository = Provider.of<AuthRepository>(context);

    try {
      await verifyPhone(authRepository, phoneNumber);
    } catch (e) {
      _changeLoadingVisible();
      print("Sign In Error: $e");
    }
  }

  Future<void> verifyPhone(AuthRepository authRepo, String phoneNumber) async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      this.verificationId = verId;
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      Navigator.pushNamed(context, '/smsCode',
          arguments: SMSCodePageArguments(this.verificationId, phoneNumber));
    };

    final PhoneVerificationCompleted verifiedSuccess = (AuthCredential user) {
      print('verified');
    };

    final PhoneVerificationFailed veriFailed = (AuthException exception) {
      print('${exception.message}');
    };

    await authRepo.sendCodeToPhoneNumber(
        phoneNumber, 5, autoRetrieve, smsCodeSent, verifiedSuccess, veriFailed);
  }

  Future<bool> smsCodeDialog(BuildContext context) {
    final TextEditingController _smsCode = new TextEditingController();
    final smsCode = TextFormField(
      keyboardType: TextInputType.number,
      autofocus: false,
      controller: _smsCode,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.sms,
            color: Colors.grey,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: 'SMS code',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          AuthRepository authRepository = Provider.of<AuthRepository>(context);
          return new AlertDialog(
            title: Text('Enter SMS Code'),
            content: smsCode,
            contentPadding: EdgeInsets.all(10.0),
            actions: <Widget>[
              new FlatButton(
                child: Text('Done'),
                onPressed: () {
                  authRepository.getCurrentUser().then((user) async {
                    if (user != null) {
                      Navigator.of(context).pop();
                      // Navigator.of(context).pushReplacementNamed('/homepage');
                    } else {
                      await signIn(
                          authRepository, this.verificationId, _smsCode.text);
                      Navigator.of(context).pop();
                    }
                  });
                },
              )
            ],
          );
        });
  }

  Future<void> signIn(
      AuthRepository authRepo, String verificationId, String smsCode) {
    return authRepo.signInWithPhoneNumber(smsCode, verificationId).then((user) {
      return;
    }).catchError((e) {
      print(e);
    });
  }
}

class SMSCodePageArguments {
  final String verificationId;
  final String phoneNumber;

  SMSCodePageArguments(this.verificationId, this.phoneNumber);
}

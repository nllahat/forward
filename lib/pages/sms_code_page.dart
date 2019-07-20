import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forward/pages/login_page.dart';
import 'package:forward/repositories/auth_repository.dart';
import 'package:forward/utils/validator_util.dart';
import 'package:forward/widgets/loading.dart';
import 'package:provider/provider.dart';

class SMSCodePage extends StatefulWidget {
  _SMSCodePageState createState() => _SMSCodePageState();
}

class _SMSCodePageState extends State<SMSCodePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _smsCode = new TextEditingController();

  bool _autoValidate = false;
  bool _loadingVisible = false;
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
              Icons.sms,
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
          _login(context: context, smsCode: _smsCode.text);
        },
        padding: EdgeInsets.all(12),
        color: Theme.of(context).primaryColor,
        child: Text('VERIFY CODE', style: TextStyle(color: Colors.white)),
      ),
    );

    final smsCode = TextFormField(
      keyboardType: TextInputType.phone,
      autofocus: false,
      controller: _smsCode,
      // validator: Validator.va,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.code,
            color: Colors.grey,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: 'Code',
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
                      smsCode,
                      SizedBox(height: 12.0),
                      loginButton,
                      // forgotLabel,
                    ],
                  ),
                ),
              ),
            ),
          ),
          inAsyncCall: _loadingVisible),
    );
  }

  void _login({String smsCode, BuildContext context}) async {
    final authRepository = Provider.of<AuthRepository>(context);
    final args = Provider.of<SMSCodePageArguments>(context);

    await authRepository.signInWithPhoneNumber(smsCode, args.verificationId);
    Navigator.pushNamed(context, '/');
  }
}

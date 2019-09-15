import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forward/core/models/user_model.dart';
import 'package:forward/repositories/auth_repository.dart';
import 'package:forward/repositories/user_repository.dart';

import 'package:forward/utils/validator_util.dart';
import 'package:forward/widgets/app_form_date_picker.dart';
import 'package:forward/widgets/radio_buttons.dart';
import 'package:forward/widgets/loading.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstName = new TextEditingController();
  final TextEditingController _lastName = new TextEditingController();
  final TextEditingController _email = new TextEditingController();

  bool _autoValidate = false;
  bool _loadingVisible = false;
  DateTime _signUpBirthDate;
  int _selectedGenderIndex = 0;
  List<GroupModel> _genderGroup = [
    GroupModel<Gender>(text: "female", index: 0, value: Gender.Female),
    GroupModel<Gender>(text: "male", index: 1, value: Gender.Male)
  ];

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

    final firstName = TextFormField(
      autofocus: false,
      textCapitalization: TextCapitalization.words,
      controller: _firstName,
      validator: ValidatorUtil.validateName,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.person,
            color: Colors.grey,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: 'First Name',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final lastName = TextFormField(
      autofocus: false,
      textCapitalization: TextCapitalization.words,
      controller: _lastName,
      validator: ValidatorUtil.validateName,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.person,
            color: Colors.grey,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: 'Last Name',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      controller: _email,
      validator: ValidatorUtil.validateEmail,
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

    final birthDate =
        AppFromDatePicker(onDateChange: (DateTime selectedBirthDate) {
      _signUpBirthDate = selectedBirthDate;
    });

    final gender = RadioButtons(
        buttons: _genderGroup,
        onChangeButton: (int value) {
          _selectedGenderIndex = value;
        });

    final signInLabel = FlatButton(
      child: Text(
        'Back to login',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {
        final authRepository = Provider.of<AuthRepository>(context);
        authRepository.signOut();
      },
    );

    final signUpButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          _signUp(
              firstName: _firstName.text,
              lastName: _lastName.text,
              // email: _email.text,
              email: _email.text,
              birthDate: _signUpBirthDate,
              gender: _genderGroup[_selectedGenderIndex].value,
              context: context);
        },
        padding: EdgeInsets.all(12),
        color: Theme.of(context).primaryColor,
        child: Text('SIGN UP', style: TextStyle(color: Colors.white)),
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
                      firstName,
                      SizedBox(height: 24.0),
                      lastName,
                      SizedBox(height: 24.0),
                      email,
                      SizedBox(height: 24.0),
                      birthDate,
                      SizedBox(height: 24.0),
                      gender,
                      SizedBox(height: 12.0),
                      signUpButton,
                      signInLabel
                    ],
                  ),
                ),
              ),
            ),
          ),
          inAsyncCall: _loadingVisible),
    );
  }

  void _signUp(
      {String firstName,
      String lastName,
      String email,
      DateTime birthDate,
      Gender gender,
      BuildContext context}) async {
    final authRepository = Provider.of<AuthRepository>(context);

    if (_formKey.currentState.validate()) {
      try {
        User newUser = new User(
          id: authRepository.appUser.firebaseUser.uid,
          firstName: firstName,
          lastName: lastName,
          email: email,
          birthDate: birthDate,
          gender: gender,
          phoneNumber: authRepository.appUser.firebaseUser.phoneNumber,
        );
        await UserRepository.addUser(newUser);
        authRepository.checkAuthStatus();
      } catch (e) {
        print("Sign Up Error: $e");
        throw e;
      }
    } else {
      setState(() => _autoValidate = true);
    }
  }
}

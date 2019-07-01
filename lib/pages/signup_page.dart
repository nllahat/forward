import 'package:flutter/material.dart';
import 'package:forward/widgets/app_form_date_picker.dart';
import 'package:forward/widgets/app_form_input.dart';
import 'package:forward/widgets/app_form_radio_buttons.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _key = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _fullNameKey = GlobalKey<FormFieldState>();
  final _phoneNumberKey = GlobalKey<FormFieldState>();
  final _genderKey = GlobalKey<FormFieldState>();
  final _emailKey = GlobalKey<FormFieldState>();
  final _birthDateKey = GlobalKey<FormFieldState>();
  List<GroupModel> _genderGroup = [
    GroupModel(
      text: "female",
      index: 1,
    ),
    GroupModel(
      text: "male",
      index: 2,
    )
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        appBar: AppBar(
          title: Text("Sign Up"),
        ),
        body: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.all(30.0),
            child: (Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                AppFormInput(
                  inputKey: _fullNameKey,
                  inputIcon: Icon(Icons.person),
                  labelText: "Full Name",
                  inputType: TextInputType.text,
                ),
                SizedBox(height: 25.0),
                AppFormInput(
                  inputKey: _phoneNumberKey,
                  inputIcon: Icon(Icons.phone),
                  labelText: "Phone Number",
                  inputType: TextInputType.phone,
                ),
                SizedBox(height: 25.0),
                AppFormInput(
                  inputKey: _emailKey,
                  inputIcon: Icon(Icons.email),
                  labelText: "Email",
                  inputType: TextInputType.emailAddress,
                ),
                SizedBox(height: 25.0),
                AppFormRadioButtons(buttons: _genderGroup),
                SizedBox(height: 25.0),
                AppFromDatePicker()
              ],
            )),
          ),
        ));
  }
}

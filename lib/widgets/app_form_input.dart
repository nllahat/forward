import 'package:flutter/material.dart';

class AppFormInput extends StatefulWidget {
  final GlobalKey<FormFieldState> inputKey;
  final FormFieldValidator<String> validator;
  final Icon inputIcon;
  final String labelText;
  final TextInputType inputType;

  AppFormInput(
      {@required this.inputKey,
      @required this.labelText,
      @required this.inputType,
      this.inputIcon,
      this.validator});

  @override
  _AppFormInputState createState() => _AppFormInputState();
}

class _AppFormInputState extends State<AppFormInput> {

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
    return Container(
      // width: 50.0,
      child: TextFormField(
        key: widget.inputKey,
        keyboardType: widget.inputType,
        validator: widget.validator,
        decoration: InputDecoration(
          prefixIcon: widget.inputIcon,
          labelText: widget.labelText,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide(color: Colors.grey, width: 2.0),
          ),
        ),
      ),
    );
  }
}

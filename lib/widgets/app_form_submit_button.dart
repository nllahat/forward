import 'package:flutter/material.dart';

class AppFormSubmitButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final Function validator;
  final Function onSubmit;
  const AppFormSubmitButton({Key key, @required this.formKey, @required this.onSubmit, this.validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: RaisedButton(
          onPressed: () {
            // Validate returns true if the form is valid, or false
            // otherwise.
            if (formKey.currentState.validate()) {
              if (validator == null || validator() == true) {
                // If the form is valid, display a Snackbar.
                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text('Processing Data')));
                this.onSubmit();
              } else {
                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text('Missing data')));
              }
            }


          },
          child: Text('Sign Up'),
        ),
      ),
    );
  }
}

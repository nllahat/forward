import 'package:flutter/material.dart';

class AppFormRadioButtons extends StatefulWidget {
  final List<GroupModel> buttons;
  final Function(int selectedIndex) onChangeButton;

  AppFormRadioButtons({@required this.buttons, @required this.onChangeButton});

  @override
  _AppFormRadioButtonsState createState() => _AppFormRadioButtonsState();
}

class _AppFormRadioButtonsState extends State<AppFormRadioButtons> {
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: widget.buttons
          .map((item) => Flexible(
                  child: RadioListTile(
                groupValue: _currentIndex,
                title: Text("${item.text}"),
                value: item.index,
                onChanged: (val) {
                  setState(() {
                    _currentIndex = val;
                    widget.onChangeButton(_currentIndex);
                  });
                },
              )))
          .toList(),
    );
  }
}

class GroupModel {
  String text;
  int index;
  GroupModel({this.text, this.index});
}

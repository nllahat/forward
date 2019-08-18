import 'package:flutter/material.dart';

class RadioButtons extends StatefulWidget {
  final List<GroupModel> buttons;
  final Function(int selectedIndex) onChangeButton;

  RadioButtons({@required this.buttons, @required this.onChangeButton});

  @override
  _RadioButtonsState createState() => _RadioButtonsState();
}

class _RadioButtonsState extends State<RadioButtons> {
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widget.buttons
          .map((item) => Flexible(
            fit: FlexFit.loose,
                  child: RadioListTile(
                activeColor: Colors.pink,
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

class GroupModel<Type> {
  String text;
  int index;
  Type value;
  GroupModel({this.text, this.index, this.value});
}


import 'package:flutter/material.dart';

class WeekDaysCheckboxes extends StatefulWidget {
  @override
  _WeekDaysCheckboxesState createState() => _WeekDaysCheckboxesState();
}

class _WeekDaysCheckboxesState extends State<WeekDaysCheckboxes> {
  bool monVal = false;
  bool tuVal = false;
  bool wedVal = false;
  bool thurVal = false;
  bool friVal = false;
  bool satVal = false;
  bool sunVal = false;

  /// box widget
  /// [title] is the name of the checkbox
  /// [boolValue] is the boolean value of the checkbox
  Widget checkbox(String title, bool boolValue) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(title),
        Checkbox(
          value: boolValue,
          onChanged: (bool value) {
            /// manage the state of each value
            setState(() {
              switch (title) {
                case "Mon":
                  monVal = value;
                  break;
                case "Tu":
                  tuVal = value;
                  break;
                case "Wed":
                  wedVal = value;
                  break;
                case "Thur":
                  thurVal = value;
                  break;
                case "Fri":
                  friVal = value;
                  break;
                case "Sat":
                  satVal = value;
                  break;
                case "Sun":
                  sunVal = value;
                  break;
              }
            });
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        checkbox("Sun", sunVal),
        checkbox("Mon", monVal),
        checkbox("Tu", tuVal),
        checkbox("Wed", wedVal),
        checkbox("Thur", thurVal),
        checkbox("Fri", friVal),
        checkbox("Sat", satVal),
      ],
    );
  }
}

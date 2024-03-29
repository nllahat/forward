import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class AppFromDatePicker extends StatefulWidget {
  final Function(DateTime date) onDateChange;

  AppFromDatePicker({@required this.onDateChange});

  @override
  _AppFromDatePickerState createState() => _AppFromDatePickerState();
}

class _AppFromDatePickerState extends State<AppFromDatePicker> {
  DateTime _selectedDate;
  DateTime _today = DateTime.now();

  @override
  Widget build(BuildContext context) {
    if (_today == null) {
      return Container();
    }

    return ListTile(
      onTap: () {
        DatePicker.showDatePicker(context,
            showTitleActions: true,
            minTime: DateTime(1930),
            maxTime: DateTime(_today.year - 5, _today.month, _today.day),
            theme: DatePickerTheme(
                backgroundColor: Colors.white,
                itemStyle:
                    TextStyle(color: Colors.pink, fontWeight: FontWeight.bold),
                doneStyle: TextStyle(color: Colors.pink, fontSize: 16)),
            onConfirm: (date) {
          if (date != null) {
            widget.onDateChange(date);
            setState(() => _selectedDate = date);
          }
          // selectedDate = date;
        }, currentTime: DateTime.now(), locale: LocaleType.en);
      },
      leading: const Icon(Icons.today),
      title: const Text('Birthday'),
      subtitle: _selectedDate != null ? Text(DateFormat('dd-MM-yyyy').format(_selectedDate)) : Text('Press to select a date'),
    );
  }
}

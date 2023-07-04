import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:kid_management/src/resources/colors.dart';

class TimePickerButton extends StatefulWidget {
  String buttonText;
  DateTime time;

  TimePickerButton({this.buttonText});

  DateTime get getTime => time;

  @override
  _TimePickerButtonState createState() => _TimePickerButtonState();
}

class _TimePickerButtonState extends State<TimePickerButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      child: RaisedButton(
        elevation: 3,
        color: widget.time == null ? Colors.white : AppColor.mainColor,
        onPressed: () {
          DatePicker.showTime12hPicker(
            context,
            currentTime: widget.time == null ? DateTime.now() : widget.time,
            locale: LocaleType.en,
            onConfirm: (time) {
              setState(() {
                widget.time = time;
                String time12Hours = DateFormat('hh:mm a').format(widget.time);
                widget.buttonText = time12Hours;
              
              });
            },
          );
        },
        child: Text(
          widget.buttonText,
          style: TextStyle(
              color: widget.time == null ? AppColor.grayDark : Colors.white),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
            side: BorderSide(
                style: BorderStyle.solid, color: AppColor.mainColor, width: 2)),
      ),
    );
  }
}

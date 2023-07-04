import 'package:flutter/material.dart';
import 'package:kid_management/src/resources/colors.dart';

class CustomSwitch extends StatefulWidget {

  bool value;
  Function onChanged;

  CustomSwitch({this.value, this.onChanged});

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  @override
  Widget build(BuildContext context) {
    return Switch(value: widget.value, onChanged: widget.onChanged,
     activeColor: AppColor.mainColor);
  }
}

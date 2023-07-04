import 'package:flutter/material.dart';
import 'package:kid_management/src/resources/colors.dart';

class DotIndicator extends StatelessWidget {
  bool isActive;

  DotIndicator({this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3.0),
      width: 10,
      height: 10,
      decoration: BoxDecoration(
          color: this.isActive ? AppColor.mainColor : null,
          shape: BoxShape.circle,
          border: Border.all(color: AppColor.mainColor)),
    );
  }
}

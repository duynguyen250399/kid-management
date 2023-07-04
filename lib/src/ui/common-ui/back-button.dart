import 'package:flutter/material.dart';
import 'package:kid_management/src/fake-data/fake_data.dart';

class GoBackButton extends StatelessWidget {
  final Color color;
  final double size;

  GoBackButton({this.color, this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: IconButton(
        icon:
            Icon(Icons.keyboard_backspace, color: this.color, size: this.size),
        onPressed: () {
          // check if keyboard is currently active then close it before pop screen
          if (MediaQuery.of(context).viewInsets.bottom != 0) {
            FocusScope.of(context).unfocus();
          } else {
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kid_management/src/models/my_app.dart';
import 'package:kid_management/src/resources/colors.dart';

class AppHistoryItem extends StatefulWidget {
  ApplicationSystem app;
  String time;
  String date;

  AppHistoryItem({this.app, this.time, this.date});

  @override
  _AppHistoryItemState createState() => _AppHistoryItemState();
}

class _AppHistoryItemState extends State<AppHistoryItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      margin: EdgeInsets.only(top: 5.0),
      decoration: BoxDecoration(
          color: AppColor.grayLight, borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        children: [
          Row(
            children: [
              Image.memory(
                widget.app.icon,
                height: 30.0,
              ),
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(widget.app.name),
                  scrollDirection: Axis.horizontal,
                ),
              ),
              SizedBox(
                width: 20.0,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                widget.time,
                style: TextStyle(color: AppColor.grayDark, fontSize: 12.0),
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(widget.date,
                  style: TextStyle(color: AppColor.grayDark, fontSize: 12.0)),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:kid_management/src/models/notification_model.dart';
import 'package:kid_management/src/resources/colors.dart';

class NotificationCard extends StatefulWidget {
  NotificationModel notificationModel;
  Function onDelete;

  NotificationCard({this.notificationModel, this.onDelete});

  @override
  _NotificationCardState createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.0,
      margin: EdgeInsets.only(top: 5.0),
      decoration: BoxDecoration(
          color: AppColor.grayLight, borderRadius: BorderRadius.circular(6.0)),
      // padding: EdgeInsets.symmetric(vertical: 20.0),
      child: Stack(
        children: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SingleChildScrollView(
                  child: Text(widget.notificationModel.msg),
                  scrollDirection: Axis.horizontal,
                ),
                Text(
                  widget.notificationModel.time,
                  style: TextStyle(color: AppColor.mainColor),
                )
              ],
            ),
          ),
          // badget to present current notification have not read yet
          Visibility(
              visible: !widget.notificationModel.isRead,
              child: Positioned(
                child: Container(
                  width: 10.0,
                  height: 10.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
                      color: Colors.redAccent),
                ),
                left: 6.0,
                top: 6.0,
              )),
          Positioned(
              child: Container(
                width: 10.0,
                height: 10.0,
                // button to remove current notification
                child: GestureDetector(
                  child: Icon(
                    Icons.clear_outlined,
                    size: 16.0,
                  ),
                  onTap: widget.onDelete,
                ),
              ),
              right: 18.0,
              top: 5.0)
        ],
      ),
    );
  }
}

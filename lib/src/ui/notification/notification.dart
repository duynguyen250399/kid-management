import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kid_management/src/fake-data/fake_data.dart';
import 'package:kid_management/src/resources/colors.dart';
import 'package:kid_management/src/ui/notification/notification_card.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
          width: size.width,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'notifications'.toUpperCase(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26.0),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // button to clear all notifications
                    Visibility(
                      visible: FakeData.notifications.length > 0,
                      child: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Center(
                                    child: Text(
                                        'Are you sure to delete all notifcations?')),
                                actions: [
                                  FlatButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                      child: Text(
                                        'NO',
                                        style: TextStyle(
                                            color: AppColor.mainColor),
                                      )),
                                  FlatButton(
                                      onPressed: () {
                                        setState(() {
                                          FakeData.notifications = [];
                                        });
                                        Navigator.of(context).pop(false);
                                      },
                                      child: Text(
                                        'YES',
                                        style: TextStyle(
                                            color: AppColor.mainColor),
                                      )),
                                ],
                              );
                            },
                          );
                        },
                        child: Row(
                          children: [
                            Text(
                              'clear all'.toUpperCase(),
                              style: TextStyle(color: AppColor.mainColor),
                            ),
                            Icon(
                              Icons.delete,
                              color: AppColor.mainColor,
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                // notification cards
                Container(
                  margin: EdgeInsets.only(top: 20.0),
                  child: FakeData.notifications.length > 0
                      ? Column(
                          children: FakeData.notifications
                              .map((notification) => NotificationCard(
                                    notificationModel: notification,
                                    onDelete: () {
                                      print('123');
                                      setState(() {
                                        FakeData.notifications
                                            .remove(notification);
                                      });
                                    },
                                  ))
                              .toList(),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 100.0),
                          child: Center(
                            child: Opacity(
                              opacity: 0.7,
                              child: Column(
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/notification/notification-bell.svg',
                                    width: 200.0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Text(
                                      'No notification currently',
                                      style:
                                          TextStyle(color: AppColor.grayDark),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                )
              ],
            ),
          )),
    );
  }
}

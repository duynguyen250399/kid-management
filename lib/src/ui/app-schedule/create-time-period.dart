import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kid_management/src/blocs/app_schedule_manager.dart';
import 'package:kid_management/src/fake-data/fake_data.dart';
import 'package:kid_management/src/helpers/datetime_helper.dart';
import 'package:kid_management/src/models/app_time_period.dart';
import 'package:kid_management/src/models/my_app.dart';
import 'package:kid_management/src/resources/colors.dart';
import 'package:kid_management/src/ui/common-ui/back-button.dart';

class CreateTimePeriodScreen extends StatefulWidget {
  DateTime startTime, endTime;
  List<ApplicationSystem> apps = FakeData.getListNonBlockingApplication();
  List<bool> appChecks = [];
  Function onCreateSuccess;

  List<ApplicationSystem> selectedApps = [];

  CreateTimePeriodScreen({this.startTime, this.endTime, this.onCreateSuccess});

  @override
  _CreateTimePeriodScreenState createState() => _CreateTimePeriodScreenState();
}

class _CreateTimePeriodScreenState extends State<CreateTimePeriodScreen> {
  // bool _connectedToSocket;
  // String _errorConnectMessage;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    widget.apps = FakeData.getListNonBlockingApplication();
    // _connectedToSocket = false;
    // _errorConnectMessage = 'Connecting...';
  }

  bool _appExist(String appName) {
    return widget.selectedApps.firstWhere(
          (app) => app.application.appName == appName,
          orElse: () => null,
        ) !=
        null;
  }

  Widget _buildStartTimePickerButton() {
    return Container(
      width: 100.0,
      child: RaisedButton(
        elevation: 3,
        color: widget.startTime == null ? Colors.white : AppColor.mainColor,
        onPressed: () {
          DatePicker.showTime12hPicker(
            context,
            currentTime:
                widget.startTime == null ? DateTime.now() : widget.startTime,
            locale: LocaleType.en,
            onConfirm: (time) {
              setState(() {
                widget.startTime = time;
              });
            },
          );
        },
        child: Text(
          widget.startTime == null
              ? 'FROM'
              : DateTimeHelper.toTime12Hours(widget.startTime),
          style: TextStyle(
              color:
                  widget.startTime == null ? AppColor.grayDark : Colors.white),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
            side: BorderSide(
                style: BorderStyle.solid, color: AppColor.mainColor, width: 2)),
      ),
    );
  }

  Widget _buildEndTimePickerButton() {
    return Container(
      width: 100.0,
      child: RaisedButton(
        elevation: 3,
        color: widget.endTime == null ? Colors.white : AppColor.mainColor,
        onPressed: () {
          if (widget.startTime != null) {
            DatePicker.showTime12hPicker(
              context,
              currentTime:
                  widget.endTime == null ? DateTime.now() : widget.endTime,
              locale: LocaleType.en,
              onConfirm: (time) {
                var dateCompare = DateTimeHelper.compareTwoDateInSeconds(
                    time, widget.startTime);
                // that mean we will update end time if selected end time is greater than given start time
                if (dateCompare > 0) {
                  setState(() {
                    widget.endTime = time;
                  });
                } else {
                  Fluttertoast.showToast(
                      msg: 'End time must be greater than start time!',
                      gravity: ToastGravity.CENTER);
                }
              },
            );
          } else {
            Fluttertoast.showToast(
                msg: 'You forgot choosing start time!',
                gravity: ToastGravity.CENTER);
          }
        },
        child: Text(
          widget.endTime == null
              ? 'TO'
              : DateTimeHelper.toTime12Hours(widget.endTime),
          style: TextStyle(
              color: widget.endTime == null ? AppColor.grayDark : Colors.white),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
            side: BorderSide(
                style: BorderStyle.solid, color: AppColor.mainColor, width: 2)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < widget.apps.length; i++) {
      widget.appChecks.add(false);
    }

    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        width: size.width,
        child: Column(
          children: <Widget>[
            Text(
              AppScheduleManager.currentAppSchedule.name.toUpperCase(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),
            ),
            SizedBox(
              height: 30.0,
            ),
            SingleChildScrollView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildStartTimePickerButton(),
                  Container(
                    child: Icon(Icons.arrow_forward_ios_outlined),
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                  ),
                  _buildEndTimePickerButton(),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.apps.length,
                itemBuilder: (context, index) {
                  var app = widget.apps[index];
                  return Row(
                    children: [
                      // SvgPicture.asset(
                      //   Icon(app.iconv2),
                      //   width: 30.0,
                      // ),
                      Image.memory(
                        app.icon,
                        height: 30.0,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(app.name),
                      Spacer(),
                      Checkbox(
                        value: widget.appChecks[index],
                        onChanged: (value) {
                          setState(() {
                            widget.appChecks[index] = value;
                            bool appIsExisted =
                                _appExist(app.application.appName);
                            if (!appIsExisted && value == true) {
                              print('selected app list added');
                              widget.selectedApps.add(app);
                            }

                            if (appIsExisted && value == false) {
                              print('selected app list removed');
                              widget.selectedApps.remove(app);
                            }
                          });
                        },
                      )
                    ],
                  );
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            // button to confirm creating time period step
            _buildSaveButton()
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      width: double.infinity,
      height: 50.0,
      child: RaisedButton(
        onPressed: () async {
          // FakeData.sendFirstSchedule();
          if (widget.startTime != null &&
              widget.endTime != null &&
              widget.selectedApps.length > 0) {
            var schedule = FakeData.listSchedule.firstWhere(
                (schedule) =>
                    schedule.id == AppScheduleManager.currentAppSchedule.id,
                orElse: null);

            // adding new time period
            if (schedule != null) {
              String startTimeString =
                  DateTimeHelper.toTime12Hours(widget.startTime);
              String endTimeString =
                  DateTimeHelper.toTime12Hours(widget.endTime);
              var appSchedule = AppScheduleManager.currentAppSchedule;

              // Check if the creating time period is not duplicated
              bool isTimeNotDuplicated =
                  DateTimeHelper.timePeriodIsNotDuplicated(startTimeString,
                      endTimeString, appSchedule.appTimePeriods);

              if (isTimeNotDuplicated) {
                var newTimePeriod = AppTimePeriod(
                    apps: widget.selectedApps,
                    id: Random.secure().nextInt(5000),
                    startTime: startTimeString,
                    endTime: endTimeString);
                schedule.appTimePeriods.add(newTimePeriod);
                await AppScheduleManager.updateAppTimePeriod(newTimePeriod);
                widget.onCreateSuccess();
                Navigator.pop(context, true);
              } else {
                var snackbar = SnackBar(
                  content: Text('This time range is existed!'),
                  duration: Duration(seconds: 3),
                );
                _scaffoldKey.currentState.showSnackBar(snackbar);
              }
            }
          } else {
            Fluttertoast.showToast(
                msg: 'Make sure you fill all data!',
                gravity: ToastGravity.CENTER);
          }
        },
        child: Text(
          'OK',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        color: AppColor.mainColor,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      ),
    );
  }
}

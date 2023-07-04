import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:kid_management/src/blocs/app_schedule_manager.dart';
import 'package:kid_management/src/fake-data/fake_data.dart';
import 'package:kid_management/src/models/app_schedule.dart';
import 'package:kid_management/src/models/app_time_period.dart';
import 'package:kid_management/src/models/my_app.dart';
import 'package:kid_management/src/resources/colors.dart';
import 'package:kid_management/src/ui/common-ui/back-button.dart';

class EditTimePriod extends StatefulWidget {
  String tmpStartTime, tmpEndTime;
  final AppTimePeriod appTimePeriod;
  final Function(AppTimePeriod period) onAppTimePeriodChanged;
  final Function onDelete;

  EditTimePriod(
      {this.appTimePeriod, this.onAppTimePeriodChanged, this.onDelete});

  @override
  _EditTimePriodState createState() => _EditTimePriodState();
}

class _EditTimePriodState extends State<EditTimePriod> {
  Map _selectedApps = {};
  List<ApplicationSystem> _allApps = FakeData.getListNonBlockingApplication();
  AppScheduleModel _currentSchedule;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    widget.appTimePeriod.apps.forEach((app) {
      _selectedApps[app.application.packageName] = true;
    });

    _allApps.forEach((app) {
      if (!_selectedApps.containsKey(app.application.packageName)) {
        _selectedApps[app.application.packageName] = false;
      }
    });

    AppScheduleManager.getAppSchedule()
        .then((schedule) => _currentSchedule = schedule);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    widget.tmpStartTime = widget.appTimePeriod.startTime;
    widget.tmpEndTime = widget.appTimePeriod.endTime;
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          actions: [
            IconButton(
                icon: Icon(
                  Icons.delete,
                  color: AppColor.mainColor,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Center(
                          child: Text('Are you sure to delete?'),
                        ),
                        actions: [
                          FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                              child: Text(
                                'NO',
                                style: TextStyle(color: AppColor.mainColor),
                              )),
                          FlatButton(
                              onPressed: () async {
                                var scheduleModel =
                                    AppScheduleManager.currentAppSchedule;
                                List<dynamic> packages = _selectedApps.keys
                                    .where((k) => _selectedApps[k] == true)
                                    .toList();
                                int periodIndex = scheduleModel.appTimePeriods
                                    .indexWhere(
                                        (e) => e.id == widget.appTimePeriod.id);

                                scheduleModel.appTimePeriods
                                    .removeAt(periodIndex);

                                bool saveJsonSuccess =
                                    await AppScheduleManager.updateAppSchedule(
                                        scheduleModel);

                                if (saveJsonSuccess) {
                                  Navigator.pop(context, 'delete_success');
                                } else {
                                  var snackbar = SnackBar(
                                    content: Text('Remove failed'),
                                    duration: Duration(seconds: 3),
                                  );
                                  _scaffoldKey.currentState
                                      .showSnackBar(snackbar);
                                }
                              },
                              child: Text(
                                'YES',
                                style: TextStyle(color: AppColor.mainColor),
                              )),
                        ],
                      );
                    },
                  ).then((value) {
                    if (value != null && value == 'delete_success') {
                      Navigator.pop(context, 'delete_success');
                    }
                  });
                })
          ],
        ),
        body: Column(
          children: [
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return ChangeTimeDialog(
                      startTime: widget.appTimePeriod.startTime,
                      endTime: widget.appTimePeriod.endTime,
                      onPeriodTimeChanged: (startTime, endTime) {
                        setState(() {
                          widget.appTimePeriod.startTime = startTime;
                          widget.appTimePeriod.endTime = endTime;
                        });
                      },
                    );
                  },
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${widget.appTimePeriod.startTime} - ${widget.appTimePeriod.endTime}',
                    style: TextStyle(fontSize: 25.0, color: AppColor.mainColor),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Icon(
                    Icons.edit,
                    color: AppColor.mainColor,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Container(
              height: size.height * 0.6,
              child: ListView.builder(
                itemCount: _allApps.length,
                itemBuilder: (context, index) {
                  var app = _allApps[index];
                  return CustomChekboxListItem(
                    isSelected: _selectedApps[app.application.packageName],
                    title: app.name,
                    icon: app.icon,
                    applicationSystem: app,
                    onChanged: (checked) {
                      setState(() {
                        _selectedApps[app.application.packageName] = checked;
                        // FakeData.setToSchedule(
                        //     widget.appScheduleModel,
                        //     widget.applicationSystem,
                        //     widget.periodIndex,
                        //     !value);
                      });
                    },
                  );
                },
              ),
            ),
            Spacer(),
            _buildSaveButton(context)
          ],
        ));
  }

  Container _buildSaveButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      margin: EdgeInsets.only(bottom: 30.0),
      width: double.infinity,
      height: 50.0,
      child: RaisedButton(
        onPressed: () async {
          if (!FakeData.isChildMode) {
            // FakeData.sendApplySchedule();
            // Store app schedule info to json file
            var scheduleModel = AppScheduleManager.currentAppSchedule;
            List<dynamic> packages = _selectedApps.keys
                .where((k) => _selectedApps[k] == true)
                .toList();
            int periodIndex = scheduleModel.appTimePeriods
                .indexWhere((e) => e.id == widget.appTimePeriod.id);

            // Update the list of apps in time period
            scheduleModel.appTimePeriods[periodIndex].apps = packages
                .map((pk) => _allApps.firstWhere(
                    (app) => app.application.packageName == pk,
                    orElse: () => null))
                .toList();

            scheduleModel.appTimePeriods[periodIndex].startTime =
                widget.appTimePeriod.startTime;
            scheduleModel.appTimePeriods[periodIndex].endTime =
                widget.appTimePeriod.endTime;

            bool saveJsonSuccess =
                await AppScheduleManager.updateAppSchedule(scheduleModel);

            if (saveJsonSuccess) {
              Navigator.pop(context);
            } else {
              var snackbar = SnackBar(
                content: Text('Save failed'),
                duration: Duration(seconds: 3),
              );
              _scaffoldKey.currentState.showSnackBar(snackbar);
            }
          }
        },
        color: AppColor.mainColor,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        child: Text(
          "OK",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class ChangeTimeDialog extends StatefulWidget {
  String startTime;
  String endTime;

  Function(String startTime, String endTime) onPeriodTimeChanged;

  ChangeTimeDialog({this.startTime, this.endTime, this.onPeriodTimeChanged});

  @override
  _ChangeTimeDialogState createState() => _ChangeTimeDialogState();
}

class _ChangeTimeDialogState extends State<ChangeTimeDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text('Change time'),
      ),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                String timeString = widget.startTime.split(' ')[0];
                String hour = timeString.split(':')[0];
                String min = timeString.split(':')[1];
                hour = hour.length <= 1 ? '0' + hour : hour;
                String dateTimeString =
                    '1999-03-25 ' + hour + ':' + min + ':00';
                DatePicker.showTime12hPicker(
                  context,
                  currentTime: DateTime.parse(dateTimeString),
                  onConfirm: (time) {
                    setState(() {
                      widget.startTime = DateFormat('hh:mm a').format(time);
                    });
                  },
                );
              },
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: Text(widget.startTime),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: AppColor.mainColor,
                        width: 2.0,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(30.0)),
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            GestureDetector(
              onTap: () {
                String timeString = widget.endTime.split(' ')[0];
                String hour = timeString.split(':')[0];
                String min = timeString.split(':')[1];
                hour = hour.length <= 1 ? '0' + hour : hour;
                String dateTimeString =
                    '1999-03-25 ' + hour + ':' + min + ':00';
                DatePicker.showTime12hPicker(
                  context,
                  currentTime: DateTime.parse(dateTimeString),
                  onConfirm: (time) {
                    setState(() {
                      widget.endTime = DateFormat('hh:mm a').format(time);
                    });
                  },
                );
              },
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: Text(widget.endTime),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: AppColor.mainColor,
                        width: 2.0,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(30.0)),
              ),
            )
          ],
        ),
      ),
      actions: [
        FlatButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text(
              'NO',
              style: TextStyle(color: AppColor.mainColor),
            )),
        FlatButton(
            onPressed: () {
              widget.onPeriodTimeChanged(widget.startTime, widget.endTime);
              Navigator.of(context).pop(true);
            },
            child: Text(
              'YES',
              style: TextStyle(color: AppColor.mainColor),
            ))
      ],
    );
  }
}

class CustomChekboxListItem extends StatefulWidget {
  String title;
  Uint8List icon;
  bool isSelected;
  ApplicationSystem applicationSystem;
  AppScheduleModel appScheduleModel;
  int periodIndex;
  Function(bool value) onChanged;

  CustomChekboxListItem(
      {this.title,
      this.icon,
      this.onChanged,
      this.isSelected,
      this.applicationSystem,
      this.appScheduleModel,
      this.periodIndex});

  @override
  _CustomChekboxListItemState createState() => _CustomChekboxListItemState();
}

class _CustomChekboxListItemState extends State<CustomChekboxListItem> {
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: widget.isSelected,
      onChanged: widget.onChanged,
      title: Text(widget.title),
      secondary: Image.memory(
        widget.icon,
        height: 30.0,
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kid_management/src/blocs/app_schedule_manager.dart';
import 'package:kid_management/src/fake-data/fake_data.dart';
import 'package:kid_management/src/models/app_schedule.dart';
import 'package:kid_management/src/resources/colors.dart';
import 'package:kid_management/src/ui/app-schedule/app_control_list.dart';
import 'package:kid_management/src/ui/app-schedule/create-time-period.dart';
import 'package:kid_management/src/ui/app-schedule/delete_schedule_page.dart';
import 'package:kid_management/src/ui/common-ui/back-button.dart';
import 'dart:collection';

class AppScheduleDetails extends StatefulWidget {
  AppScheduleDetails();
  @override
  _AppScheduleDetailsState createState() => _AppScheduleDetailsState();
}

class _AppScheduleDetailsState extends State<AppScheduleDetails> {
  AppScheduleModel currentSchedule;
  Future<AppScheduleModel> _scheduleFuture;

  @override
  void initState() {
    super.initState();
    AppScheduleManager.getAppSchedule().then((value) {
      setState(() {
        currentSchedule = value;
      });
    });
  }

// turn on a schedule and turn off all of others
  void _turnOnSchedule(int scheduleId) {
    var schedules = FakeData.listSchedule;
    schedules.forEach((schedule) {
      if (schedule.id == scheduleId) {
        schedule.active = true;
      } else {
        schedule.active = false;
      }
    });
    FakeData.sendApplySchedule();
  }

  @override
  Widget build(BuildContext context) {
    // _scheduleFuture = AppScheduleManager.getAppSchedule();
    if (currentSchedule == null) {
      return Scaffold(
        body: Container(),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: [
            // switch button to toggle on or off sate of the schedule
            // _buildScheduleStatusSwitch(),
            // // schedule name here
            TextField(
              textAlign: TextAlign.center,
              onChanged: (value) => {
                setState(() => {
                      currentSchedule.name = value,
                      AppScheduleManager.updateAppSchedule(currentSchedule)
                    })
              },
              controller: TextEditingController(
                  text: currentSchedule.name.toUpperCase()),
              style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          width: 2.0,
                          color: AppColor.mainColor,
                          style: BorderStyle.solid))),
            ),
            // the list of controlling apps
            currentSchedule?.appTimePeriods?.isEmpty ?? true
                ? Expanded(child: _emptyApp())
                : AppControlList(
                    appScheduleModel: currentSchedule,
                    onScheduleUpdated: () async {
                      currentSchedule =
                          await AppScheduleManager.getAppSchedule();
                      if (mounted) {
                        setState(() {});
                      }
                    },
                  ),
            Container(
              height: 100.0,
            ),
            DayOfWeeks(
              dayOfWeeks: currentSchedule.dayOfWeeks,
              onDateOfWeekChanged: (value) => {
                setState(() => {
                      currentSchedule.dayOfWeeks = value,
                      AppScheduleManager.updateAppSchedule(currentSchedule)
                    })
              },
            )
          ],
        ),
      ),
      // button to add new time period to the schedule
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.blue[800],
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateTimePeriodScreen(
                  onCreateSuccess: () async {
                    currentSchedule = await AppScheduleManager.getAppSchedule();
                    if (mounted) {
                      setState(() {});
                    }
                  },
                ),
              )).then((createSuccess) {
            // if (createSuccess) {
            //   if (mounted) {
            //     setState(() {});
            //   }
            // }
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildDeleteScheduleButton() {
    return IconButton(
        icon: Icon(
          Icons.delete_forever,
          color: AppColor.mainColor,
          size: 35.0,
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DeleteSchedulePage(),
              )).then((value) {
            if (value == 'schedule_deleted') {
              Navigator.pop(context);
            }
          });
        });
  }

  Widget _buildScheduleStatusSwitch() {
    return Transform.scale(
      scale: 1.5,
      child: Switch(
        value: AppScheduleManager.currentAppSchedule.active,
        activeColor: AppColor.mainColor,
        onChanged: (value) {
          String status = value == true ? 'ON' : 'OFF';
          setState(() {
            AppScheduleManager.currentAppSchedule.active = value;
            if (value == true) {
              _turnOnSchedule(AppScheduleManager.currentAppSchedule.id);
            } else {
              _turnOnSchedule(-1);
            }
            Fluttertoast.showToast(
                msg: 'Schedule is $status',
                gravity: ToastGravity.CENTER,
                backgroundColor: AppColor.grayDark,
                textColor: Colors.white);
          });
        },
      ),
    );
  }

  Widget _emptyApp() {
    return Column(
      children: [
        SizedBox(
          height: 100.0,
        ),
        Opacity(
            opacity: 0.5,
            child: SvgPicture.asset('assets/images/app-schedule/empty_app.svg',
                width: 200.0)),
        Text("There's no app in control")
      ],
    );
  }
}

class DayOfWeeks extends StatefulWidget {
  Set<int> dayOfWeeks;
  Function(Set<int>) onDateOfWeekChanged;
  DayOfWeeks({@required this.dayOfWeeks, this.onDateOfWeekChanged});

  @override
  _DayOfWeeksState createState() => _DayOfWeeksState();
}

class _DayOfWeeksState extends State<DayOfWeeks> {
  Widget _dayOfWeekChip(String label, int value, bool isActive) {
    return Container(
      width: 50.0,
      margin: EdgeInsets.symmetric(horizontal: 1.0),
      child: RaisedButton(
        // press this chip to active or inactive day of week
        onPressed: () {
          setState(() {
            if (widget.dayOfWeeks.contains(value)) {
              widget.dayOfWeeks.remove(value);
            } else {
              widget.dayOfWeeks.add(value);
            }
            widget.dayOfWeeks =
                SplayTreeSet.from(widget.dayOfWeeks, (a, b) => a.compareTo(b));
            widget.onDateOfWeekChanged(widget.dayOfWeeks);
          });
        },
        color: isActive ? AppColor.mainColor : Colors.white,
        elevation: 0,
        padding: EdgeInsets.all(0.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        child: Text(label.toUpperCase(),
            style: TextStyle(
              color: isActive ? Colors.white : AppColor.grayDark,
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Padding(
        padding: EdgeInsets.symmetric(vertical: 5.0),
        child: Text('DAYS OF WEEK'),
      ),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          _dayOfWeekChip('mon', 2, this.widget.dayOfWeeks.contains(2)),
          _dayOfWeekChip('tue', 3, this.widget.dayOfWeeks.contains(3)),
          _dayOfWeekChip('wed', 4, this.widget.dayOfWeeks.contains(4)),
          _dayOfWeekChip('thu', 5, this.widget.dayOfWeeks.contains(5)),
          _dayOfWeekChip('fri', 6, this.widget.dayOfWeeks.contains(6)),
          _dayOfWeekChip('sat', 7, this.widget.dayOfWeeks.contains(7)),
          _dayOfWeekChip('sun', 8, this.widget.dayOfWeeks.contains(8))
        ]),
      )
    ]);
  }
}

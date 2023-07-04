import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:kid_management/src/blocs/bloc.dart';
import 'package:kid_management/src/blocs/provider.dart';
import 'package:kid_management/src/fake-data/fake_data.dart';
import 'package:kid_management/src/helpers/datetime_helper.dart';
import 'package:kid_management/src/models/app_schedule.dart';
import 'package:kid_management/src/models/app_time_period.dart';
import 'package:kid_management/src/models/my_app.dart';
import 'package:kid_management/src/resources/colors.dart';
import 'package:kid_management/src/ui/app-schedule/EditTimePeriod.dart';

class ChildrenAppControlList extends StatefulWidget {
  AppScheduleModel appScheduleModel;

  ChildrenAppControlList({this.appScheduleModel});

  @override
  _ChildrenAppControlListState createState() => _ChildrenAppControlListState();
}

class _ChildrenAppControlListState extends State<ChildrenAppControlList> {
  List<bool> _timePeriodsCollapse = [];

  Timer _timer;

  @override
  initState() {
    super.initState();
  }

  Widget _appListItem(ApplicationSystem app) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              child: Image.memory(
                app.icon,
                height: 30.0,
              ),
              padding: EdgeInsets.all(5.0),
            ),
            SizedBox(
              width: 20.0,
            ),
            Text(app.name, textAlign: TextAlign.right),
            Spacer(),
            // Text('Remain: 3:00',
            //     style: TextStyle(color: AppColor.mainColor),
            //     textAlign: TextAlign.right),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final _bloc = new Bloc();
    _bloc.getAppSchedule();
    return StreamBuilder(
        stream: _bloc.schedule,
        builder: (context, AsyncSnapshot<AppScheduleModel> snapshot) {
          List<AppTimePeriod> periods;
          if (snapshot.hasData) {
            periods = snapshot.data.appTimePeriods;
            for (int i = 0; i < periods.length; i++) {
              _timePeriodsCollapse.add(false);
            }
            return Expanded(
              child: ListView.builder(
                // shrinkWrap: true,
                itemBuilder: (context, index) {
                  AppTimePeriod period;
                  try {
                    period = snapshot.data.appTimePeriods[index];
                  } catch (e) {
                    print("object");
                    return Container();
                  }

                  // check if the current period is in time period of now date time
                  bool inProgress =
                      FakeData.comparePeriodWithNowDate(period) > 0
                          ? true
                          : false;
                  // calculate remaining time
                  var remainingTimeInMinutes =
                      DateTimeHelper.toDateTime(period.endTime)
                          .difference(DateTime.now())
                          .inMinutes;

                  if (remainingTimeInMinutes > 0) {
                    _timer = Timer.periodic(Duration(seconds: 60), (timer) {
                      setState(() {});
                    });
                  }

                  return Container(
                    margin: EdgeInsets.only(top: 10.0),
                    padding: EdgeInsets.only(
                        left: 20.0, right: 20.0, bottom: 30.0, top: 10.0),
                    decoration: BoxDecoration(
                        color: AppColor.grayLight,
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            inProgress
                                ? 'Time remaining: ${DateTimeHelper.minuteToString(remainingTimeInMinutes)}'
                                : 'Not Started',
                            style: TextStyle(
                                color: inProgress
                                    ? AppColor.mainColor
                                    : AppColor.grayDark),
                          ),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // collapse toggle button
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _timePeriodsCollapse[index] =
                                        !_timePeriodsCollapse[index];
                                  });
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.timelapse,
                                      color: AppColor.mainColor,
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Text(
                                      '${period.startTime} - ${period.endTime}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Icon(
                                _timePeriodsCollapse[index]
                                    ? Icons.keyboard_arrow_down
                                    : Icons.keyboard_arrow_right,
                                size: 24.0,
                              )
                            ],
                          ),
                          // margin: EdgeInsets.only(bottom: 10.0, top: 10.0),
                        ),
                        Visibility(
                          child: period.apps.length == 0
                              ? Center(
                                  child: Text("There's no time period"),
                                )
                              : Column(
                                  children: period.apps
                                      .map((app) => _appListItem(app))
                                      .toList(),
                                ),
                          visible: _timePeriodsCollapse[index],
                        )
                      ],
                    ),
                  );
                },
                itemCount: snapshot.data.appTimePeriods.length,
              ),
            );
          } else if (snapshot.hasError) {
            periods = new List<AppTimePeriod>();
          }
          return Expanded(
            child: ListView.builder(
              // shrinkWrap: true,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(top: 10.0),
                  padding: EdgeInsets.only(
                      left: 20.0, right: 20.0, bottom: 30.0, top: 10.0),
                  decoration: BoxDecoration(
                      color: AppColor.grayLight,
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [],
                  ),
                );
              },
              itemCount: 0,
            ),
          );
        });
  }
}

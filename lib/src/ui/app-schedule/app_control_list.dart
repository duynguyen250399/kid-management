import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kid_management/src/blocs/app_schedule_manager.dart';
import 'package:kid_management/src/models/app_schedule.dart';
import 'package:kid_management/src/models/my_app.dart';
import 'package:kid_management/src/resources/colors.dart';
import 'package:kid_management/src/ui/app-schedule/EditTimePeriod.dart';

class AppControlList extends StatefulWidget {
  AppScheduleModel appScheduleModel;
  Function onScheduleUpdated;

  AppControlList({this.appScheduleModel, this.onScheduleUpdated});

  @override
  _AppControlListState createState() => _AppControlListState();
}

class _AppControlListState extends State<AppControlList> {
  List<bool> _timePeriodsCollapse = [];

  @override
  initState() {
    super.initState();
  }

  Widget _appListItem(ApplicationSystem app) {
    return Column(
      children: [
        Row(
          children: [
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
            Text(app.name)
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var periods = widget.appScheduleModel.appTimePeriods;
    for (int i = 0; i < periods.length; i++) {
      _timePeriodsCollapse.add(true);
    }
    print(_timePeriodsCollapse.length);
    return Expanded(
      child: ListView.builder(
        // shrinkWrap: true,
        itemBuilder: (context, index) {
          var period =
              AppScheduleManager.currentAppSchedule.appTimePeriods[index];
          return Column(
            children: [
              Container(
                child: Row(
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
                          Text('${period.startTime} - ${period.endTime}',
                              style: TextStyle(color: AppColor.grayDark)),
                          Icon(!_timePeriodsCollapse[index]
                              ? Icons.keyboard_arrow_down
                              : Icons.keyboard_arrow_right)
                        ],
                      ),
                    ),
                    Spacer(),
                    // button to edit app time period
                    InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                            color: AppColor.mainColor,
                            borderRadius: BorderRadius.circular(100.0)),
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 18.0,
                        ),
                        padding: EdgeInsets.all(5.0),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditTimePriod(
                                appTimePeriod: period,
                              ),
                            )).then((value) {
                          if (value != null && value == 'delete_success') {
                            Fluttertoast.showToast(
                                msg: 'Time period has been removed',
                                toastLength: Toast.LENGTH_LONG);
                          }
                          widget.onScheduleUpdated();
                        });
                      },
                    )
                  ],
                ),
                margin: EdgeInsets.only(bottom: 10.0, top: 10.0),
              ),
              Visibility(
                child: period.apps.length == 0
                    ? Center(
                        child: Text("There's no app currently in schedule"),
                      )
                    : Column(
                        children: period.apps
                            .map((app) => _appListItem(app))
                            .toList(),
                      ),
                visible: !_timePeriodsCollapse[index],
              )
            ],
          );
        },
        itemCount: widget.appScheduleModel.appTimePeriods.length,
      ),
    );
  }
}

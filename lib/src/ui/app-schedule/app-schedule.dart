import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kid_management/src/blocs/app_schedule_manager.dart';
import 'package:kid_management/src/models/app_schedule.dart';
import 'package:kid_management/src/resources/colors.dart';
import 'package:kid_management/src/resources/constant.dart' as CONSTANT;
import 'package:kid_management/src/theme/icon_theme.dart';
import 'package:kid_management/src/ui/app-schedule/app-schedule-details.dart';
import 'package:kid_management/src/ui/common-ui/back-button.dart';

class AppSchedule extends StatefulWidget {
  @override
  _AppScheduleState createState() => _AppScheduleState();
}

class _AppScheduleState extends State<AppSchedule> {
  Future<AppScheduleModel> _scheduleFuture;

  @override
  void initState() {
    _scheduleFuture = AppScheduleManager.getAppSchedule();
  }

  Widget _emptySchedule() {
    return Column(
      children: [
        SizedBox(
          height: 100.0,
        ),
        Center(
          child: SvgPicture.asset(
            CONSTANT.URL_IMG_BG_APP_SCHEDULE_EMPTY,
            width: 200.0,
            height: 200.0,
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Center(
          child: Text(
            "There's no app schedule",
            style:
                TextStyle(color: Colors.black.withOpacity(0.3), fontSize: 14.0),
          ),
        ),
        Center(
          child: Text("Tap Plus Icon to add new one",
              style: TextStyle(
                  color: Colors.black.withOpacity(0.3), fontSize: 14.0)),
        )
      ],
    );
  }

  Widget _appSchedule(AppScheduleModel appSchedule) {
    String daysOfWeek = appSchedule.toDayOfWeeksString();

    return Container(
      margin: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
      child: RaisedButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 0,
        // route to schedule details screen
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AppScheduleDetails(),
              )).then((value) {
            setState(() {});
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appSchedule.name.toUpperCase(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20.0),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    daysOfWeek,
                    style: TextStyle(color: AppColor.grayDark, fontSize: 14.0),
                  ),
                ],
              ),
              Visibility(
                visible: appSchedule.active,
                child: SvgPicture.asset(
                  'assets/images/app-schedule/checked.svg',
                  width: 22.0,
                ),
              )
            ],
          ),
        ),
        color: AppColor.grayLight,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // generate fake data
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        elevation: 0
      ),
      body: Column(children: [
        SizedBox(
          height: 10.0,
        ),
        Center(
          child: Text(
            'YOUR APP SCHEDULE',
            style: TextStyle(fontSize: 25.0),
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
        Center(
          child: Text(
            'Build your schedule to use apps',
            style:
                TextStyle(fontSize: 16.0, color: Colors.black.withOpacity(0.5)),
          ),
        ),
        SizedBox(height: 20.0),
        FutureBuilder<AppScheduleModel>(
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var schedule = snapshot.data;
              debugPrint('has schedule');
              return SingleChildScrollView(
                child: Column(
                  children: [
                    _appSchedule(schedule),
                  ],
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
          future: _scheduleFuture,
        ),
      ]),
      // button to add new app schedule
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //             builder: (context) => CreateAppScheduleStep01(
      //                   appScheduleModel: AppScheduleModel(
      //                       appTimePeriods: [],
      //                       dayOfWeeks: Set<int>(),
      //                       active: false),
      //                 ))).then((value) {
      //       setState(() {});
      //     });
      //   },
      //   child: Icon(Icons.add),
      //   backgroundColor: AppColor.mainColor,
      // )
    );
  }
}

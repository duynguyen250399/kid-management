import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kid_management/src/fake-data/fake_data.dart';
import 'package:kid_management/src/models/app_schedule.dart';
import 'package:kid_management/src/resources/colors.dart';
import 'package:kid_management/src/ui/app-blocking/app_blocking.dart';
import 'package:kid_management/src/ui/app-schedule/app-schedule.dart';
import 'package:kid_management/src/ui/common-ui/back-button.dart';
import 'package:kid_management/src/resources/constant.dart' as CONSTANT;

class AppManagement extends StatefulWidget {
  @override
  _AppManagementState createState() => _AppManagementState();
}

class _AppManagementState extends State<AppManagement> {
  final databaseReference = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // firebase
    try {
      databaseReference
          .child(FakeData.parentName)
          .once()
          .then((DataSnapshot snapshot) {
        var listSchedule = snapshot.value[CONSTANT.ROOT_SCHEDULES] as List;
        if (listSchedule.length > 0) {
          var listScheduleRaw = new List<AppScheduleModel>();
          for (var schedule in listSchedule) {
            var schedules = FakeData.convertToSchedule(schedule);
            if (schedule != null) {
              listScheduleRaw.add(schedules);
            }
          }
          FakeData.listSchedule = listScheduleRaw;
        }
      });
    } catch (e) {
      print('Error: ' + e.message);
    }
  }

  Widget _appScheduleGradientButton(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    Gradient gradient = LinearGradient(
        colors: [Color(0xff7F74DF), Color(0xff463AB0)],
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        tileMode: TileMode.mirror);

    return RaisedButton(
      padding: EdgeInsets.all(0.0),
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AppSchedule(),
        ));
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        decoration: BoxDecoration(
            gradient: gradient, borderRadius: BorderRadius.circular(10.0)),
        child: Container(
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 20.0),
          child: Row(
            children: [
              Container(
                width: deviceWidth * 0.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'APP SCHEDULE',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 26.0),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text('Limit the time to use apps for your kid',
                        style: TextStyle(color: Colors.white))
                  ],
                ),
              ),
              SizedBox(
                width: deviceWidth * 0.15,
              ),
              Container(
                child: Column(
                  children: [
                    Container(
                      child: SvgPicture.asset(
                        'assets/images/app-management/clock.svg',
                        width: 50.0,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _appBlockingGradientButton(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    Gradient gradient = LinearGradient(
        colors: [Color(0xffE3B673), Color(0xffB0813A)],
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        tileMode: TileMode.mirror);

    return RaisedButton(
      padding: EdgeInsets.all(0.0),
      onPressed: () {
        // navigate to App Blocking Screen
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AppBlocking(),
        ));
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        decoration: BoxDecoration(
            gradient: gradient, borderRadius: BorderRadius.circular(10.0)),
        child: Container(
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 20.0),
          child: Row(
            children: [
              Container(
                width: deviceWidth * 0.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'APP BLOCKING',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 26.0),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text('Prevent your kid using some apps',
                        style: TextStyle(color: Colors.white))
                  ],
                ),
              ),
              SizedBox(
                width: deviceWidth * 0.15,
              ),
              Container(
                child: Column(
                  children: [
                    Container(
                      child: SvgPicture.asset(
                        'assets/images/app-management/app-phone.svg',
                        width: 50.0,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'APPS CONTROL',
          style: TextStyle(
              color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 20.0,
            ),
            // Container(
            //     margin: EdgeInsets.symmetric(vertical: 20.0),
            //     child: Opacity(
            //       opacity: 0.7,
            //       child: SvgPicture.asset(
            //         'assets/images/app-management/kitty.svg',
            //         width: 150.0,
            //       ),
            //     )),
            // Text(
            //   'Well, we have these features for you!',
            //   style: TextStyle(fontSize: 16.0, color: AppColor.grayDark),
            // ),
            SizedBox(
              height: 20.0,
            ),
            _appScheduleGradientButton(context),
            SizedBox(
              height: 10.0,
            ),
            _appBlockingGradientButton(context)
          ],
        ),
      ),
    );
  }
}

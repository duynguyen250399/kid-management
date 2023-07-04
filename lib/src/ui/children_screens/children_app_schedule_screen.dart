import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kid_management/src/blocs/provider.dart';
import 'package:kid_management/src/fake-data/fake_data.dart';
import 'package:kid_management/src/models/app_schedule.dart';
import 'package:kid_management/src/ui/app-schedule/app_control_list.dart';
import 'package:kid_management/src/ui/children_screens/components/children_app_control_list.dart';
import 'package:kid_management/src/resources/constant.dart' as CONSTANT;

class ChildrenAppScheduleScreen extends StatefulWidget {
  @override
  _ChildrenAppScheduleScreenState createState() =>
      _ChildrenAppScheduleScreenState();
}

class _ChildrenAppScheduleScreenState extends State<ChildrenAppScheduleScreen> {
  // fake data to demo
  AppScheduleModel _appSchedule;
  final databaseReference = FirebaseDatabase.instance.reference();
  @override
  void initState() {
    super.initState();
    // firebase
    try {
      databaseReference.child(FakeData.parentName).onValue.listen((event) {
        var snapshot = event.snapshot;
        var listSchedule = snapshot.value[CONSTANT.ROOT_SCHEDULES] as List;
        var schedule = listSchedule[0];
        setState(() {
          _appSchedule = FakeData.convertToSchedule(schedule);
        });
      });
    } catch (e) {
      _showErrorDialog(e.message);
    }
  }

  Future<void> _showErrorDialog(String msg) async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(msg),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        children: [
          SvgPicture.asset(
            'assets/images/kid-screen/task.svg',
            width: 60,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Text(
              "Hey! Let's see your schedule to use app",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.0, letterSpacing: 2.0),
              softWrap: true,
            ),
          ),
          ChildrenAppControlList(
            appScheduleModel: _appSchedule,
          ),
        ],
      ),
    );
  }
}

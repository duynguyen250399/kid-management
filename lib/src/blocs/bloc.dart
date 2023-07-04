import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:kid_management/src/blocs/app_schedule_manager.dart';
import 'package:kid_management/src/fake-data/fake_data.dart';
import 'package:kid_management/src/helpers/datetime_helper.dart';
import 'package:kid_management/src/models/app_schedule.dart';
import 'package:kid_management/src/models/app_time_period.dart';
import 'package:kid_management/src/resources/constant.dart' as CONSTANT;
import 'package:shared_preferences/shared_preferences.dart';

class Bloc {
  //Our pizza house
  final fakeData = StreamController<AppScheduleModel>();
  final periodData = StreamController<AppTimePeriod>();
  final collapseData = StreamController<List<bool>>();
  AppScheduleModel _appScheduleModel;
  Stream<AppScheduleModel> get schedule => fakeData.stream;
  Stream<AppTimePeriod> get appTimePeriod => periodData.stream;
  Stream<List<bool>> get collapse => collapseData.stream;
  Bloc();
  Timer _timer;
  final databaseReference = FirebaseDatabase.instance.reference();
  Future<void> listenScheduleTimeChange() async {
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
    }
    _timer = Timer.periodic(Duration(milliseconds: FakeData.timeReRunApp),
        (timer) async {
      if (_appScheduleModel != null) {
        var schedule = await refreshAppScheduleModel();
        AppTimePeriod validPeriod = FakeData.getCurrentPeriod(schedule);
        refreshAppTimePeriod(validPeriod);
      }
    });
  }

  Future<AppScheduleModel> refreshAppScheduleModel() async {
    _appScheduleModel = await AppScheduleManager.getAppSchedule();
    return _appScheduleModel;
  }

  void getAppSchedule() {
    AppScheduleManager.getAppSchedule().then((schedule) => {
          refreshSchedule(schedule),
          refreshAppTimePeriod(FakeData.getCurrentPeriod(schedule))
        });
  }

  void listenFirebaseChange() {
    // bool hasData = false;
    // try {
    //   databaseReference.child(FakeData.parentName).onValue.listen((event) {
    //     if (FakeData.isChildMode) {
    //       var snapshot = event.snapshot;
    //       var listSchedule = snapshot.value[CONSTANT.ROOT_SCHEDULES] as List;
    //       if ((listSchedule?.length ?? true) != 0) {
    //         var schedule = listSchedule[0];
    //         var scheduleData = FakeData.convertToSchedule(schedule);
    //         if (scheduleData.active) {
    //           hasData = true;
    //           refreshSchedule(scheduleData);
    //           refreshAppTimePeriod(getCurrentPeriod());
    //         }
    //       }
    //     }
    //   });
    // } catch (e) {
    //   print('Error when read firebase: ' + e.message);
    // }
    // if (!hasData) {
    //   refreshSchedule(null);
    //   refreshAppTimePeriod(null);
    // }
  }

  //Validate if pizza can be baked or not. This is John
  final refreshData =
      StreamTransformer<AppScheduleModel, AppScheduleModel>.fromHandlers(
          handleData: (schedule, sink) {
    sink.add(schedule);
  });

  //refresh order
  void refreshSchedule(AppScheduleModel schedule) {
    if (schedule != null) {
      AppScheduleManager.updateAppSchedule(schedule);
      _appScheduleModel = schedule;
    }

    fakeData.sink.add(schedule);
  }

  void refreshAppTimePeriod(AppTimePeriod period) async {
    if (period != null) {
      try {
        // var prefs = await SharedPreferences.getInstance();
        // await prefs.reload();
        // var currentPackage = prefs.get(FakeData.currentKey);
        // bool isInListApp = false;
        // for (var i = 0; i < period.apps.length; i++) {
        //   var currentAPP = period.apps[i];
        //   if (currentPackage == currentAPP.application.packageName) {
        //     isInListApp = true;
        //   }
        // }
        // if (!isInListApp && period.apps.length > 0) {
        //   prefs.setString(
        //       FakeData.currentKey, period.apps.first.application.packageName);
        // }
      } catch (e) {
        print("error bloc: " + e.toString());
      }
    }
    periodData.sink.add(period);
  }

  void refreshTimePeriodCollapse(List<AppTimePeriod> periods) {
    var listCollapse = new List<bool>();
    for (int i = 0; i < periods.length; i++) {
      listCollapse.add(false);
    }
    collapseData.sink.add(listCollapse);
  }
}

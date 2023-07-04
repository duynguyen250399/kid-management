import 'dart:async';
import 'dart:ui';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kid_management/src/blocs/app_schedule_manager.dart';
import 'package:kid_management/src/blocs/provider.dart';
import 'package:kid_management/src/fake-data/app_user_manager.dart';
import 'package:kid_management/src/fake-data/fake_data.dart';
import 'package:kid_management/src/theme/theme.dart';
import 'package:kid_management/src/ui/kid-screens/kid_control.dart';
import 'package:kid_management/src/ui/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FakeData.initData();
  AndroidAlarmManager.cancel(FakeData.serviceKey);
  IsolateNameServer.registerPortWithName(
    FakeData.port.sendPort,
    FakeData.isolateName,
  );
  if (!(await AppUserManager.existFile())) {
    AppUserManager.initFileUserModel();
  }
  String sr = await rootBundle.loadString('assets/resources/config.json');
  var data = json.decode(sr);
  if (data["time-rerun-app"] != null) {
    FakeData.timeReRunApp = data["time-rerun-app"];
  }
  FakeData.setIsContinueRunApp(true);
  await AndroidAlarmManager.initialize();
  // AndroidAlarmManager.periodic(
  //   const Duration(seconds: 10),
  //   // Ensure we have a unique alarm ID.
  //   FakeData.serviceKey,
  //   refreshApplicationInTime,
  //   exact: true,
  //   wakeup: true,
  // );

  Timer _timer;
  _timer = Timer.periodic(Duration(milliseconds: FakeData.timeReRunApp),
      (timer) async {
    await refreshApplicationInTime();
  });
  await Firebase.initializeApp();
  runApp(MyApp());

  // AndroidAlarmManager.cancel(0);
}

// using for refresh
// open app when start kid app
Future<void> refreshApplicationInTime() async {
  var isContinue = await FakeData.getIsContinueRunApp();
  if (isContinue ?? false) {
    print("refresh application: " + DateTime.now().toString());
    var prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    String currentPackage = prefs.get(FakeData.currentKey);
    print(DateTime.now().toString());
    // get schedule
    var schedule = await AppScheduleManager.getAppSchedule();
    print(DateTime.now().toString());
    print(schedule.toJson());
    var period = FakeData.getCurrentPeriod(schedule);
    if (period != null) {
      // check current auto start app is current in list app
      bool checkCurrentPackage = period.apps
          .any((element) => element.application.packageName == currentPackage);
      if (!checkCurrentPackage) {
        try {
          currentPackage = period.apps.first.application.packageName;
        } catch (StateError) {
          currentPackage = "";
        }
      }
    } else {
      currentPackage = "";
    }
    prefs.setString(FakeData.currentKey, currentPackage);
    prefs.reload();
    if (!(currentPackage?.isEmpty ?? true)) {
      DeviceApps.openApp(currentPackage);
    } else {
      DeviceApps.openApp(FakeData.kidAppPackage);
    }
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Prevent the user from rotating device
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // home: WelcomeAnimation(),
        home: WelcomeAnimation(),
        theme: appThemeData(),
        routes: <String, WidgetBuilder>{
          '/HomeScreen': (BuildContext context) => new KidPage()
        },
      ),
    );
  }
}

class WelcomeAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      height: MediaQuery.of(context).size.height,
    );
  }
}

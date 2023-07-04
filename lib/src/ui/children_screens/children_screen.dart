import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kid_management/src/fake-data/fake_data.dart';
import 'package:kid_management/src/resources/colors.dart';
import 'package:kid_management/src/ui/children_screens/children_app_schedule_screen.dart';
import 'package:kid_management/src/ui/children_screens/children_home_screen.dart';
import 'package:kid_management/src/ui/children_screens/parents_mode_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_apps/device_apps.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:kid_management/src/resources/constant.dart' as CONSTANT;

class ChildrenScreen extends StatefulWidget {
  @override
  _ChildrenScreenState createState() => _ChildrenScreenState();
}

class _ChildrenScreenState extends State<ChildrenScreen>
    with WidgetsBindingObserver {
  int _currentPageIndex = 0;
  List<Widget> _pages = [
    ChildrenHomeScreen(),
    ChildrenAppScheduleScreen(),
    ParentsModeScreen()
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // init childrent user
    FakeData.isChildMode = true;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    print('state of app = $state');

    if (state == AppLifecycleState.resumed) {
      FakeData.setIsContinueRunApp(true);
    }
  }

  Future<void> showprint() async {
    try {
      if (FakeData.isContinueRunApp) {
        print(DateTime.now().toString());
        var prefs = await SharedPreferences.getInstance();
        await prefs.reload();
        var temp = prefs.get(FakeData.currentKey);
        var packageName = '';
        if (temp != null) {
          packageName = temp.toString();
          DeviceApps.openApp(packageName);
        } else {
          DeviceApps.openApp(FakeData.kidAppPackage);
        }
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () {},
          child: Container(
            child: _pages[_currentPageIndex],
          ),
        ),
      ),
      // Bottom nav bar
      bottomNavigationBar: Container(
        height: 90,
        decoration: BoxDecoration(
          color: AppColor.mainColor.withOpacity(0.15),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Opacity(
                      opacity: _currentPageIndex == 0 ? 1 : 0.4,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            FakeData.setIsContinueRunApp(true);
                            _currentPageIndex = 0;
                          });
                        },
                        child: SvgPicture.asset(
                          'assets/images/kid-screen/menu_list.svg',
                          width: 40.0,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Opacity(
                      opacity: _currentPageIndex == 1 ? 1 : 0.4,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _currentPageIndex = 1;
                          });
                        },
                        child: SvgPicture.asset(
                          'assets/images/kid-screen/calendar.svg',
                          width: 40.0,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Opacity(
                      opacity: _currentPageIndex == 2 ? 1 : 0.4,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            FakeData.setIsContinueRunApp(false);
                            _currentPageIndex = 2;
                          });
                        },
                        child: SvgPicture.asset(
                          'assets/images/kid-screen/setting.svg',
                          width: 40.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Spacer(),
              Wrap(children: <Widget>[
                Text(
                  'Created by hunguyen1499@gmail.com',
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 13.0,
                      color: Color(0xFF162A49)),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    try {
      AndroidAlarmManager.cancel(FakeData.serviceKey);
    } catch (e) {
      print("[error][childrent_screen.dart]: can't remove service");
    }
    super.dispose();
  }
}

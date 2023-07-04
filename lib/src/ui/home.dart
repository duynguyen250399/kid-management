import 'package:flutter/material.dart';
import 'package:kid_management/src/resources/colors.dart';
import 'package:kid_management/src/resources/constant.dart' as CONSTANT;
import 'package:kid_management/src/ui/app_management.dart';

class HomePage extends StatelessWidget {
  final String _appControl = "Apps Control";
  final String _webFilter = "Web Filter";
  final String _screenBlocking = "Screen Blocking";
  final String _locationTracking = "Location Tracking";
  final String _schedule = "Schedule";
  final String _activityReport = "Activity Report";

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _title(),
            ),
            Container(
              padding: EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: deviceHeight * 0.21),
                      height: deviceHeight * 0.58,
                      child: GridView.count(
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          crossAxisCount: 2,
                          children: [
                            _appList(_appControl, CONSTANT.URL_IMG_APP_CONTROL,
                                AppManagement(), context),
                            _appList(_webFilter, CONSTANT.URL_IMG_WEB_FILTER,
                                null, context),
                            _appList(
                                _screenBlocking,
                                CONSTANT.URL_IMG_SCREEN_BLOCKING,
                                null,
                                context),
                            _appList(
                                _locationTracking,
                                CONSTANT.URL_IMG_LOCATION_TRACKING,
                                null,
                                context),
                            _appList(_schedule, CONSTANT.URL_IMG_SCHEDULE, null,
                                context),
                            _appList(_activityReport,
                                CONSTANT.URL_IMG_ACTIVITY_REPORT, null, context)
                          ]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget _title() {
    return Container(
      height: 250.0,
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/main_dashboard/svg_bg.png'))),
      child: Column(
        children: [
          Image.asset(
            CONSTANT.URL_IMG_KID_SPACE_LOGO,
          ),
        ],
      ),
    );
  }

  Widget _appList(
      String title, String img, Widget screen, BuildContext context) {
    return Container(
      child: RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          elevation: 0,
          onPressed: () {
            // display the snack bar if screen is null
            if (screen == null) {
              print('Coming soon!');
            } else {
              // route to given screen
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => screen,
                  ));
            }
          },
          color: AppColor.grayLight,
          child: Padding(
            padding: EdgeInsets.all(0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  img,
                  width: 80.0,
                  height: 80.0,
                ),
                SizedBox(height: 30),
                Text(
                  title,
                  style:
                      TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
                )
              ],
            ),
          )),
    );
  }
}

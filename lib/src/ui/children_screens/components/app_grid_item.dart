import 'dart:math';

import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:kid_management/src/fake-data/fake_data.dart';
import 'package:kid_management/src/models/my_app.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as json;

class AppGridItem extends StatefulWidget {
  Function(String) onAppChange;
  ApplicationSystem app;

  AppGridItem({this.app, this.onAppChange});

  @override
  _AppGridItemState createState() => _AppGridItemState();
}

class _AppGridItemState extends State<AppGridItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        FakeData.currentApp = widget.app;
        //FakeData.openApp(widget.app);
        await FakeData.setIsContinueRunApp(true);
        SharedPreferences.getInstance().then((prefs) => {
              prefs.setString(
                  FakeData.currentKey, widget.app.application.packageName),
              prefs.reload()
            });
        widget.onAppChange(widget.app.application.appName);
      },
      child: Container(
        child: Column(
          children: [
            SizedBox(
              child: Image(image: MemoryImage(widget.app.icon)),
              width: 50,
            ),
            SizedBox(
              height: 5.0,
            ),
            Flexible(
              child: Text(
                widget.app.name,
                style: TextStyle(fontSize: 12.0),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}

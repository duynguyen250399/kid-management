import 'package:device_apps/device_apps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kid_management/src/fake-data/fake_data.dart';
import 'package:kid_management/src/models/my_app.dart';
import 'package:kid_management/src/resources/colors.dart';

class AppCheckboxList extends StatefulWidget {
  @override
  _AppCheckboxListState createState() => _AppCheckboxListState();
}

class _AppCheckboxListState extends State<AppCheckboxList> {
  bool showSystemApps = false;
  bool isSelected = false;

  Future<List<ApplicationSystem>> _getApps() async {
    var apps = await FakeData.getListNonBlockingApplication();
    return apps;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getApps(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: AppColor.grayLight,
              valueColor: AlwaysStoppedAnimation<Color>(AppColor.mainColor),
            ),
          );
        } else {
          List<ApplicationSystem> apps = snapshot.data;
          // filter KidSpace app
          apps.removeWhere((app) => app.application.appName == 'Kid Space');

          if (apps.length > 0) {
            return Expanded(
              child: ListView.builder(
                itemCount: apps.length,
                itemBuilder: (context, index) {
                  ApplicationSystem app = apps[index];

                  return Container(
                    child: Column(
                      children: [
                        CustomCheckboxListTile(
                          app: app,
                          isSelected: false,
                        ),
                        Divider(
                          color: AppColor.grayLight,
                        )
                      ],
                    ),
                  );
                },
              ),
            );
          } else {
            return Center(
              child: Text(
                "There's no app installed on your device",
                style: TextStyle(fontSize: 20.0, color: AppColor.grayDark),
              ),
            );
          }
        }
      },
    );
  }
}

class CustomCheckboxListTile extends StatefulWidget {
  ApplicationSystem app;
  bool isSelected;

  CustomCheckboxListTile({this.app, this.isSelected});

  @override
  _CustomCheckboxListTileState createState() => _CustomCheckboxListTileState();
}

class _CustomCheckboxListTileState extends State<CustomCheckboxListTile> {
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
        activeColor: AppColor.mainColorLight,
        onChanged: (value) {
          setState(() {
            this.widget.isSelected = value;
            // if app is selected then add it to temp list
            if (this.widget.isSelected) {
              var apps = FakeData.listApplication;
              apps.forEach((app) {
                if (app.application.packageName ==
                        widget.app.application.packageName &&
                    app.application.appName == widget.app.application.appName) {
                  FakeData.tempAppList.add(widget.app);
                }
              });
            } else {
              // if app is unselected then remove it from temp list
              FakeData.tempAppList.removeWhere((app) =>
                  app.application.packageName ==
                      widget.app.application.packageName &&
                  app.application.appName == widget.app.application.appName);
            }
            print(FakeData.tempAppList.length);
          });
        },
        title: Text(widget.app.application.appName),
        value: this.widget.isSelected,
        // app icon
        secondary: widget.app.application is ApplicationWithIcon
            ? CircleAvatar(
                backgroundImage: MemoryImage(widget.app.application.icon),
                backgroundColor: Colors.white,
              )
            : null);
  }
}

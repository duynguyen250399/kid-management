import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:kid_management/src/models/my_app.dart';
import 'package:kid_management/src/ui/children_screens/components/app_grid_item.dart';

class AppByCategoryPageView extends StatefulWidget {
  List<ApplicationSystem> apps;
  ApplicationCategory appCategory;
  Function(String) onAppChange;

  AppByCategoryPageView({this.apps, this.appCategory, this.onAppChange});

  @override
  _AppByCategoryPageViewState createState() => _AppByCategoryPageViewState();
}

class _AppByCategoryPageViewState extends State<AppByCategoryPageView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5.0),
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 30.0),
      decoration: BoxDecoration(
          color: Colors.black.withAlpha(10),
          borderRadius: BorderRadius.circular(10.0)),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 3,
        childAspectRatio: 1,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        children: widget.apps.map((app) {
          return AppGridItem(
            app: app,
            onAppChange: (value) {
              widget.onAppChange(value);
            },
          );
        })?.toList(),
      ),
    );
  }
}

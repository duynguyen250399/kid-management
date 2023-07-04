import 'dart:async';

import 'package:device_apps/device_apps.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kid_management/src/blocs/bloc.dart';
import 'package:kid_management/src/fake-data/fake_data.dart';
import 'package:kid_management/src/models/app_time_period.dart';
import 'package:kid_management/src/models/my_app.dart';
import 'package:kid_management/src/ui/children_screens/components/app_by_category_page_view.dart';
import 'package:kid_management/src/ui/children_screens/components/dot_indicator.dart';

class ChildrenHomeScreen extends StatefulWidget {
  @override
  _ChildrenHomeScreenState createState() => _ChildrenHomeScreenState();
}

class _ChildrenHomeScreenState extends State<ChildrenHomeScreen> {
  Bloc _bloc;
  // mockup data for testing new app list view
  List<ApplicationSystem> _apps = FakeData.listApplication;
  // list of app categories
  Set<ApplicationCategory> _appCategories = Set();
  // list of categorized apps
  List<List<ApplicationSystem>> _listOfAppsByCategory = [];
  int _currentAppPageViewIndex = 0;
  ApplicationCategory _currentAppCategory;
  String currentAppName = "N/A";
  final databaseReference = FirebaseDatabase.instance.reference();
  String currentCategoryName = 'Unknown';
  @override
  void initState() {
    super.initState();
    _apps = new List<ApplicationSystem>();
    _bloc = new Bloc();
  }

  String _toAppCategoryString(ApplicationCategory _currentAppCategory) {
    if (_currentAppCategory == null) return 'Unknown';
    String categoryString = _currentAppCategory.toString();
    if (categoryString.split('.')[1] == 'undefined') return 'Unknown';

    return categoryString.split('.')[1];
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
    _bloc.listenScheduleTimeChange();
    _bloc.getAppSchedule();
    return StreamBuilder(
        stream: _bloc.appTimePeriod,
        builder: (context, AsyncSnapshot<AppTimePeriod> snapshot) {
          if (snapshot.hasData) {
            var schedule = snapshot.data;
            if (schedule != null) {
              _apps = new List<ApplicationSystem>();
              _appCategories = new Set<ApplicationCategory>();
              _listOfAppsByCategory = new List<List<ApplicationSystem>>();
              _apps = snapshot.data.apps;
              if (_apps == null || _apps.length == 0) {
                return Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Grid view to show all apps
                      Expanded(
                          child: PageView.builder(
                        itemBuilder: (context, index) {},
                      )),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                                _listOfAppsByCategory.length, (index) {
                              return DotIndicator(
                                isActive: _currentAppPageViewIndex == index,
                              );
                            }),
                          )),
                      // text to display name of app category
                      Text(
                        'NO APPs',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                );
              }
              // initialize app categories
              _apps.forEach((app) {
                _appCategories.add(app.application.category);
              });

              // split app list to sub lists by app category
              _appCategories.forEach((category) {
                var appsByCategory = _apps
                    .where((a) => a.application.category == category)
                    .toList();
                _listOfAppsByCategory.add(appsByCategory);
              });

              return Container(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // SvgPicture.asset(
                    //   'assets/images/kid-screen/kid_home_logo.svg',
                    //   width: 80.0,
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 10.0),
                    //   child: Text(
                    //     'hello! i am kidspace'.toUpperCase(),
                    //     style: TextStyle(
                    //       fontWeight: FontWeight.bold,
                    //       fontSize: 20.0,
                    //       letterSpacing: 3.0,
                    //     ),
                    //     textAlign: TextAlign.center,
                    //   ),
                    // ),
                    // Text(
                    //   'Play around with your phone',
                    //   style:
                    //       TextStyle(color: AppColor.grayDark, fontSize: 16.0),
                    //   textAlign: TextAlign.center,
                    // ),

                    // Grid view to show all apps
                    Expanded(
                        child: PageView.builder(
                      onPageChanged: (value) {
                        setState(() {
                          _currentAppPageViewIndex = value;
                          _currentAppCategory =
                              _listOfAppsByCategory[_currentAppPageViewIndex][0]
                                  .application
                                  .category;
                          currentCategoryName =
                              _toAppCategoryString(_currentAppCategory);
                        });
                      },
                      itemBuilder: (context, index) {
                        var apps = _listOfAppsByCategory[index];
                        var appCategory = apps[0].application.category;
                        // using only 1 app
                        apps = _apps;
                        appCategory = apps[0].application.category;

                        // page view display list of apps filtered by category
                        return AppByCategoryPageView(
                          apps: apps,
                          appCategory: appCategory,
                          onAppChange: (value) {
                            setState(() {
                              currentAppName = value;
                            });
                          },
                        );
                      },
                      itemCount: 1,
                    )),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(_listOfAppsByCategory.length,
                              (index) {
                            return DotIndicator(
                              isActive: _currentAppPageViewIndex == index,
                            );
                          }),
                        )),
                    // text to display name of app category
                    Text(
                      // currentCategoryName.toUpperCase(),
                      currentAppName.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              );
            } else {
              return Container(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // SvgPicture.asset(
                    //   'assets/images/kid-screen/kid_home_logo.svg',
                    //   width: 80.0,
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 10.0),
                    //   child: Text(
                    //     'hello! i am kidspace'.toUpperCase(),
                    //     style: TextStyle(
                    //       fontWeight: FontWeight.bold,
                    //       fontSize: 20.0,
                    //       letterSpacing: 3.0,
                    //     ),
                    //     textAlign: TextAlign.center,
                    //   ),
                    // ),
                    // Text(
                    //   'Play around with your phone',
                    //   style:
                    //       TextStyle(color: AppColor.grayDark, fontSize: 16.0),
                    //   textAlign: TextAlign.center,
                    // ),

                    // Grid view to show all apps
                    Expanded(
                        child: PageView.builder(
                      itemBuilder: (context, index) {},
                    )),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(_listOfAppsByCategory.length,
                              (index) {
                            return DotIndicator(
                              isActive: _currentAppPageViewIndex == index,
                            );
                          }),
                        )),
                    // text to display name of app category
                    Text(
                      'NO APPs',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              );
            }
          }
          return Container(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // SvgPicture.asset(
                //   'assets/images/kid-screen/kid_home_logo.svg',
                //   width: 80.0,
                // ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 10.0),
                //   child: Text(
                //     'hello! i am kidspace'.toUpperCase(),
                //     style: TextStyle(
                //       fontWeight: FontWeight.bold,
                //       fontSize: 20.0,
                //       letterSpacing: 3.0,
                //     ),
                //     textAlign: TextAlign.center,
                //   ),
                // ),
                // Text(
                //   'Play around with your phone',
                //   style: TextStyle(color: AppColor.grayDark, fontSize: 16.0),
                //   textAlign: TextAlign.center,
                // ),

                // Grid view to show all apps
                Expanded(
                    child: PageView.builder(
                  itemBuilder: (context, index) {},
                )),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                          List.generate(_listOfAppsByCategory.length, (index) {
                        return DotIndicator(
                          isActive: _currentAppPageViewIndex == index,
                        );
                      }),
                    )),
                // text to display name of app category
                Text(
                  'NO APPs',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
          );
        });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}

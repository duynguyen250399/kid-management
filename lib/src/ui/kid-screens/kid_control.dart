import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:kid_management/main.dart';
import 'package:kid_management/src/fake-data/fake_data.dart';
import 'package:kid_management/src/models/my_app.dart';
import 'package:kid_management/src/resources/colors.dart';
import 'package:kid_management/src/ui/kid_app.dart';

class KidPage extends StatefulWidget {
  @override
  _KidPageState createState() => _KidPageState();
}

// Master screen to navigate another screens using bottom nav bar
class _KidPageState extends State<KidPage> {
  List<ApplicationModel> features = new List<ApplicationModel>();
  @override
  void initState() {
    super.initState();
    var listApplication = FakeData.getListNonBlockingApplication();
    listApplication.forEach((element) {
      features.add(new ApplicationModel(
          icon: element.icon, label: element.name, myApp: element));
    });
  }

  Widget _featureCard(ApplicationModel feature, BuildContext context) {
    return InkWell(
      onTap: () {
        if (feature.myApp != null) {
          FakeData.openApp(feature.myApp);
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: Text('This feature will be coming soon'),
              title: Text(
                "Woops! We're sorry for this inconvenient",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          );
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white, width: 1),
          borderRadius: BorderRadius.circular(50),
        ),
        elevation: 3,
        color: Colors.white,
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.memory(
                  feature.icon,
                  height: 50.0,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Center(
                  child: Text(
                    feature.label.toUpperCase(),
                    style:
                        TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          child: SafeArea(
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [],
                      ),
                    ),
                    Flexible(
                      child: GridView.count(
                          childAspectRatio: 1.0,
                          crossAxisCount: 3,
                          crossAxisSpacing: 5.0,
                          mainAxisSpacing: 5.0,
                          children: features.map((feature) {
                            return _featureCard(feature, context);
                          }).toList()),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => KidApp()));
          },
          child: Icon(Icons.home_outlined),
          backgroundColor: AppColor.mainColorLight,
        ));
  }
}

class ApplicationModel {
  String label;
  Uint8List icon;
  Widget route;
  ApplicationSystem myApp;

  ApplicationModel({this.label, this.icon, this.route, this.myApp});
}

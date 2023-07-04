import 'dart:typed_data';

import 'package:device_apps/device_apps.dart';
import 'package:flutter/cupertino.dart';

class ApplicationSystem {
  String name;
  Uint8List icon;
  ApplicationWithIcon application;
  bool isBlock;

  ApplicationSystem({this.name, this.icon, this.application, this.isBlock});

  ApplicationSystem.toApplication(ApplicationWithIcon application) {
    name = application.appName;
    this.icon = application.icon;
    this.application = application;
    this.isBlock = false;
  }
}

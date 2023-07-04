import 'package:kid_management/src/models/app_time_period.dart';
import 'dart:collection';

class AppScheduleModel {
  int id;
  String name;
  bool active;
  List<AppTimePeriod> appTimePeriods;
  Set<int> dayOfWeeks = new Set<int>();

  AppScheduleModel(
      {this.id, this.name, this.active, this.appTimePeriods, this.dayOfWeeks});

  // int get getId => id;
  // String get getName => name;
  // Color get getColor => color;
  // bool get isActive => active;
  // List<AppTimePeriod> get getAppTimePeriods => appTimePeriods;
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "active": active,
        "day-of-weeks": List<int>.from(dayOfWeeks.map((x) => x)),
        "app-time-periods": appTimePeriods.map((e) => e.toJson()).toList()
      };
  factory AppScheduleModel.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    var result = AppScheduleModel(
      id: json["id"],
      name: json["name"],
      active: json["active"],
      dayOfWeeks: Set<int>.from(json["day-of-weeks"].map((x) => x)),
      appTimePeriods: List<AppTimePeriod>.from(
          json["app-time-periods"].map((x) => AppTimePeriod.fromJson(x))),
    );
    return result;
  }

  String toDayOfWeeksString() {
    if (this.dayOfWeeks?.isEmpty ?? true) {
      return '';
    }

    String result = '';
    this.dayOfWeeks =
        SplayTreeSet.from(this.dayOfWeeks, (a, b) => a.compareTo(b));
    for (int i = 0; i < this.dayOfWeeks.length; i++) {
      int d = this.dayOfWeeks.elementAt(i);
      String dayString = '';
      switch (d) {
        case 2:
          dayString = 'Mon';
          break;
        case 3:
          dayString = 'Tue';
          break;
        case 4:
          dayString = 'Wed';
          break;
        case 5:
          dayString = 'Thu';
          break;
        case 6:
          dayString = 'Fri';
          break;
        case 7:
          dayString = 'Sat';
          break;
        case 8:
          dayString = 'Sun';
      }
      result += dayString + ', ';
    }

    return result.substring(0, result.length - 2);
  }
}

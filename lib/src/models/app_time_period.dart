import 'package:kid_management/src/fake-data/fake_data.dart';
import 'package:kid_management/src/models/my_app.dart';

class AppTimePeriod {
  int id;
  String startTime;
  String endTime;
  List<ApplicationSystem> apps;

  AppTimePeriod({this.id, this.startTime, this.endTime, this.apps});
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "start-time": startTime,
      "end-time": endTime,
      "apps": apps != null
          ? apps
              .map((appSystem) => appSystem?.application?.packageName ?? "")
              .toList()
          : [],
    };
  }

  factory AppTimePeriod.fromJson(Map<String, dynamic> json) {
    // Lookup application objects based on its package name
    List<ApplicationSystem> allApps = FakeData.getListAllApplication();
    List<dynamic> appPackages = json["apps"];
    var _appsInControl = appPackages
        .map((pk) => allApps.firstWhere(
            (app) => app.application.packageName == pk,
            orElse: () => null))
        .toList();
    _appsInControl = _appsInControl
        .where((element) =>
            (element?.application?.packageName == null ? false : true) == true)
        .toList();
    var _appTimePeriod = AppTimePeriod(
      id: json["id"],
      startTime: json["start-time"],
      endTime: json["end-time"],
      apps: _appsInControl,
    );

    return _appTimePeriod;
  }
}

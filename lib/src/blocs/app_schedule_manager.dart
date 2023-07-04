import 'package:kid_management/src/fake-data/fake_data.dart';
import 'package:kid_management/src/helpers/file_helper.dart';
import 'package:kid_management/src/models/app_schedule.dart';
import 'package:kid_management/src/models/app_time_period.dart';
import 'package:kid_management/src/resources/constant.dart';
import 'package:path_provider/path_provider.dart';

class AppScheduleManager {
  static AppScheduleModel _cache;

  static AppScheduleModel get currentAppSchedule => _cache;

  static Future<AppScheduleModel> getAppSchedule() async {
    var dir = await getExternalStorageDirectory();
    print(dir.path);
    var filePath = '${dir.path}/$APP_SCHEDULE_JSON_DIR';

    var mapObj = await FileHelper.readJsonFile(filePath);

    _cache = AppScheduleModel.fromJson(mapObj);
    if (_cache == null) {
      if (!(await AppScheduleManager.existFile())) {
        updateAppSchedule(FakeData.listSchedule[0]);
        _cache = FakeData.listSchedule[0];
      }
    } else {
      _cache.appTimePeriods
          .toList()
          .sort((a, b) => a.startTime.compareTo(b.startTime));
    }
    return _cache;
  }

  static Future<bool> existFile() async {
    var dir = await getExternalStorageDirectory();
    var filePath = '${dir.path}/$APP_SCHEDULE_JSON_DIR';
    var result = await FileHelper.existFile(filePath);
    return result;
  }

  static Future<bool> updateAppSchedule(AppScheduleModel scheduleModel) async {
    scheduleModel.appTimePeriods
        .toList()
        .sort((a, b) => a.startTime.compareTo(b.startTime));
    var dir = await getExternalStorageDirectory();
    var filePath = '${dir.path}/$APP_SCHEDULE_JSON_DIR';
    var appScheduleMap = scheduleModel.toJson();

    bool success = await FileHelper.writeToJsonFile(appScheduleMap, filePath);

    if (success) {
      _cache = scheduleModel;
    }

    return success;
  }

  static Future<void> updateAppTimePeriod(AppTimePeriod appTimePeriod) async {
    var dir = await getExternalStorageDirectory();
    var filePath = '${dir.path}/$APP_SCHEDULE_JSON_DIR';
    if (await existFile()) {
      var schedule = await getAppSchedule();
      if (schedule != null) {
        schedule.appTimePeriods.add(appTimePeriod);
        var appScheduleMap = schedule.toJson();
        var success =
            await FileHelper.writeToJsonFile(appScheduleMap, filePath);
        if (success) {
          print('time period added');
          _cache = schedule;
        }
      }
    }
  }
}

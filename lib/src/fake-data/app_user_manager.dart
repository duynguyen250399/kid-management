import 'package:kid_management/src/fake-data/fake_data.dart';
import 'package:kid_management/src/helpers/file_helper.dart';
import 'package:kid_management/src/models/app_schedule.dart';
import 'package:kid_management/src/models/app_time_period.dart';
import 'package:kid_management/src/resources/constant.dart';
import 'package:path_provider/path_provider.dart';
import 'package:crypt/crypt.dart';

import 'dart:convert';

class UserLogin {
  UserLogin({
    this.username,
    this.password,
  });

  String username;
  String password;

  UserLogin copyWith({
    String username,
    String password,
  }) =>
      UserLogin(
        username: username ?? this.username,
        password: password ?? this.password,
      );

  factory UserLogin.fromJson(Map<String, dynamic> json) => UserLogin(
        username: json["username"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
      };
}

class AppUserManager {
  static final String salt = "hunguyen1499@gmail.com";
  static final String defaultUsername = "admin";
  static final String defaultPassword = "admin";
  static Future<bool> login(String username, String password) async {
    var dir = await getExternalStorageDirectory();
    print(dir.path);
    var filePath = '${dir.path}/$APP_USER_JSON_DIR';

    var mapObj = await FileHelper.readJsonFile(filePath);
    var hashPassword = Crypt.sha512(password, rounds: 10000, salt: salt);
    UserLogin user = UserLogin.fromJson(mapObj);
    if (user.username == username && user.password == hashPassword.toString()) {
      return true;
    }
    return false;
  }

  static Future<void> initFileUserModel() async {
    var hashPassword = Crypt.sha512(defaultPassword, rounds: 10000, salt: salt);
    var userModel = new UserLogin(
        username: defaultUsername, password: hashPassword.toString());
    var dir = await getExternalStorageDirectory();
    var filePath = '${dir.path}/$APP_USER_JSON_DIR';
    var appScheduleMap = userModel.toJson();
    await FileHelper.writeToJsonFile(appScheduleMap, filePath);
  }

  static Future<bool> existFile() async {
    var dir = await getExternalStorageDirectory();
    var filePath = '${dir.path}/$APP_USER_JSON_DIR';
    var result = await FileHelper.existFile(filePath);
    return result;
  }

  static Future<bool> updatePassword(String passwordUpdated) async {
    var dir = await getExternalStorageDirectory();
    print(dir.path);
    var filePath = '${dir.path}/$APP_USER_JSON_DIR';

    var mapObj = await FileHelper.readJsonFile(filePath);
    var hashPassword = Crypt.sha512(passwordUpdated, rounds: 10000, salt: salt);
    UserLogin user = UserLogin.fromJson(mapObj);
    user.password = hashPassword.toString();
    await FileHelper.writeToJsonFile(user.toJson(), filePath);
    return false;
  }
}

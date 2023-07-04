import 'dart:convert';
import 'dart:io';

class FileHelper {
  static Future<bool> writeToJsonFile(
      Map<String, dynamic> jsonData, String filePath) async {
    try {
      File file = File(filePath);
      var fileExisted = await file.exists();

      if (!fileExisted) {
        file = await file.create(recursive: true);
      }
      file.writeAsStringSync(json.encode(jsonData));

      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  static Future<bool> existFile(String filePath) async {
    try {
      File file = File(filePath);
      var fileExisted = await file.exists();

      return fileExisted;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  static Future<Map<String, dynamic>> readJsonFile(String filePath) async {
    try {
      File file = File(filePath);
      var fileExisted = await file.exists();

      if (!fileExisted) {
        file = await file.create(recursive: true);
      }
      var jsonString = await file.readAsString();
      var jsonMap = json.decode(jsonString);
      return jsonMap;
    } catch (e) {
      print(e.toString());
      
      return null;
    }
  }
}

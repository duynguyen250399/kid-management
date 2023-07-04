import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:kid_management/src/models/app_time_period.dart';

class DateTimeHelper {
  // convert 12-hours time format string to Datetime obj
  // 12:00 AM -> 0 h
  // 12:00 PM -> 12 h
  // 11:00 PM -> 23 h
  // 12:59 PM -> 12:59
  // 11:59 PM -> 23:59 -> qua 24h( tức 0h sáng) là 12:00 AM
  static DateTime toDateTime(String timeString) {
    String startTimeString = timeString.split(' ')[0];
    // AM or PM
    String startTimeMode = timeString.split(' ')[1];

    String startHourString = startTimeString.split(':')[0];
    startHourString =
        startHourString.length == 1 ? '0$startHourString' : startHourString;

    startHourString = startTimeMode == 'AM'
        ? (startHourString == "12" ? "00" : startHourString)
        : startHourString == "12"
            ? "12"
            : (int.parse(startHourString) + 12).toString();
    String startMinuteString = startTimeString.split(':')[1];

    String currentDateString = DateTime.now().toString().split(' ')[0];

    DateTime dateTimeObj = DateTime.parse(
        '$currentDateString $startHourString:$startMinuteString:00');
    
    return dateTimeObj;
  }

  static String minuteToString(int minutes) {
    var d = Duration(minutes: minutes);
    List<String> parts = d.toString().split(':');
    parts.forEach((element) {
      print(element);
    });
    return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
  }

  static int compareTwoDateInSeconds(DateTime dateOne, DateTime dateTwo) {
    var diff = dateOne.difference(dateTwo);
    return diff.inSeconds;
  }

  static String toTime12Hours(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }

  static bool timePeriodIsNotDuplicated(
      String startTime, String endTime, List<AppTimePeriod> periods) {
    for (int i = 0; i < periods.length; i++) {
      var period = periods[i];
      if (startTime.toUpperCase().compareTo(period.startTime.toUpperCase()) ==
              0 ||
          endTime.toUpperCase().compareTo(period.endTime.toUpperCase()) == 0) {
        debugPrint('duplicate');
        return false;
      }
    }

    return true;
  }
}

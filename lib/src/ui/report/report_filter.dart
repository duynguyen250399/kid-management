import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:kid_management/src/resources/colors.dart';
import 'package:kid_management/src/ui/common-ui/back-button.dart';

class ReportFilterScreen extends StatefulWidget {
  @override
  _ReportFilterScreenState createState() => _ReportFilterScreenState();
}

class _ReportFilterScreenState extends State<ReportFilterScreen> {
  String _currentFilterValue = 'day';
  String _currentFilterDayValue = 'alldays';
  String _currentFilterMonthValue = 'allmonths';
  String _currentFilterWeekValue = 'allweeks';

  final String filterByDay = 'day';
  final String filterByWeek = 'week';
  final String filterByMonth = 'month';

  final String filterAllDays = 'alldays';
  final String filterToday = 'today';
  final String filterYesterday = 'yesterday';
  final String filterSpecificDay = 'specificday';

  final String filterAllMonths = 'allmonths';
  final String filterSpecificMonth = 'specificmonth';
  final String filterCurrentMonth = 'currentmonth';

  final String filterAllWeeks = 'allweeks';
  final String filterPreviousWeek = 'previousweek';
  final String filterCurrentWeek = 'currentweek';

  bool _dayFilterToggle = false;
  bool _monthFilterToggle = false;
  bool _weekFilterToggle = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Text(
            'report filter'.toUpperCase(),
            style: TextStyle(
                color: Colors.black,
                fontSize: 22.0,
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            // filter by day
            RadioListTile(
              onChanged: (value) {
                setState(() {
                  _currentFilterValue = value;
                });
                print(value);
              },
              title: Text(
                'Filter by day',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              groupValue: _currentFilterValue,
              activeColor: AppColor.mainColor,
              value: filterByDay,
              secondary: _currentFilterValue != 'day'
                  ? Icon(Icons.keyboard_arrow_down)
                  : null,
            ),
            Visibility(
              visible: _currentFilterValue == 'day',
              child: Container(
                decoration: BoxDecoration(
                    color: AppColor.grayLight,
                    borderRadius: BorderRadius.circular(5.0)),
                // padding: EdgeInsets.only(left: 20.0),
                child: Column(
                  children: [
                    RadioListTile(
                      title: Text(
                        'All days',
                        style: TextStyle(fontSize: 14.0),
                      ),
                      activeColor: AppColor.mainColorLight,
                      value: filterAllDays,
                      groupValue: _currentFilterDayValue,
                      onChanged: (value) {
                        setState(() {
                          _currentFilterDayValue = value;
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text('Today', style: TextStyle(fontSize: 14.0)),
                      value: filterToday,
                      activeColor: AppColor.mainColorLight,
                      groupValue: _currentFilterDayValue,
                      onChanged: (value) {
                        setState(() {
                          _currentFilterDayValue = value;
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text(
                        'Yesterday',
                        style: TextStyle(fontSize: 14.0),
                      ),
                      value: filterYesterday,
                      activeColor: AppColor.mainColorLight,
                      groupValue: _currentFilterDayValue,
                      onChanged: (value) {
                        setState(() {
                          _currentFilterDayValue = value;
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text(
                        'Specific day',
                        style: TextStyle(fontSize: 14.0),
                      ),
                      value: filterSpecificDay,
                      activeColor: AppColor.mainColorLight,
                      groupValue: _currentFilterDayValue,
                      onChanged: (value) {
                        DatePicker.showDatePicker(context, onConfirm: (time) {
                          setState(() {
                            _currentFilterDayValue = value;
                          });
                        },
                            onCancel: () {},
                            minTime: DateTime.now()
                                .subtract(Duration(days: 365 * 3)),
                            maxTime: DateTime.now());
                      },
                    ),
                  ],
                ),
              ),
            ),
            RadioListTile(
              onChanged: (value) {
                setState(() {
                  _currentFilterValue = value;
                });
              },
              title: Text(
                'Filter by week',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              groupValue: _currentFilterValue,
              activeColor: AppColor.mainColor,
              value: filterByWeek,
              secondary: _currentFilterValue != 'week'
                  ? Icon(Icons.keyboard_arrow_down)
                  : null,
            ),
            Visibility(
              visible: _currentFilterValue == 'week',
              child: Container(
                decoration: BoxDecoration(
                    color: AppColor.grayLight,
                    borderRadius: BorderRadius.circular(5.0)),
                // padding: EdgeInsets.only(left: 20.0),
                child: Column(
                  children: [
                    RadioListTile(
                      title: Text(
                        'All weeks',
                        style: TextStyle(fontSize: 14.0),
                      ),
                      activeColor: AppColor.mainColorLight,
                      value: filterAllWeeks,
                      groupValue: _currentFilterWeekValue,
                      onChanged: (value) {
                        setState(() {
                          _currentFilterWeekValue = value;
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text('Current week',
                          style: TextStyle(fontSize: 14.0)),
                      value: filterCurrentWeek,
                      activeColor: AppColor.mainColorLight,
                      groupValue: _currentFilterWeekValue,
                      onChanged: (value) {
                        setState(() {
                          _currentFilterWeekValue = value;
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text(
                        'Previous week',
                        style: TextStyle(fontSize: 14.0),
                      ),
                      value: filterPreviousWeek,
                      activeColor: AppColor.mainColorLight,
                      groupValue: _currentFilterWeekValue,
                      onChanged: (value) {
                        setState(() {
                          _currentFilterWeekValue = value;
                        });
                      },
                    )
                  ],
                ),
              ),
            ),
            RadioListTile(
              onChanged: (value) {
                setState(() {
                  _currentFilterValue = value;
                });
              },
              title: Text(
                'Filter by month',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              groupValue: _currentFilterValue,
              activeColor: AppColor.mainColor,
              value: filterByMonth,
              secondary: _currentFilterValue != 'month'
                  ? Icon(Icons.keyboard_arrow_down)
                  : null,
            ),
            Visibility(
              visible: _currentFilterValue == 'month',
              child: Container(
                decoration: BoxDecoration(
                    color: AppColor.grayLight,
                    borderRadius: BorderRadius.circular(5.0)),
                // padding: EdgeInsets.only(left: 20.0),
                child: Column(
                  children: [
                    RadioListTile(
                      title: Text(
                        'All months',
                        style: TextStyle(fontSize: 14.0),
                      ),
                      activeColor: AppColor.mainColorLight,
                      value: filterAllMonths,
                      groupValue: _currentFilterMonthValue,
                      onChanged: (value) {
                        setState(() {
                          _currentFilterMonthValue = value;
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text('Current month',
                          style: TextStyle(fontSize: 14.0)),
                      value: filterCurrentMonth,
                      activeColor: AppColor.mainColorLight,
                      groupValue: _currentFilterMonthValue,
                      onChanged: (value) {
                        setState(() {
                          _currentFilterMonthValue = value;
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text(
                        'Specific month',
                        style: TextStyle(fontSize: 14.0),
                      ),
                      value: filterSpecificMonth,
                      activeColor: AppColor.mainColorLight,
                      groupValue: _currentFilterMonthValue,
                      onChanged: (value) {
                        DatePicker.showDatePicker(context, onConfirm: (time) {
                          setState(() {
                            _currentFilterMonthValue = value;
                          });
                        },
                            onCancel: () {},
                            minTime: DateTime.now()
                                .subtract(Duration(days: 365 * 3)),
                            maxTime: DateTime.now());
                      },
                    )
                  ],
                ),
              ),
            ),
            Spacer(),
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Center(
                child: Text(
                  'OK',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              color: AppColor.mainColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
            ),
            SizedBox(
              height: 20.0,
            )
          ],
        ),
      ),
    );
  }
}

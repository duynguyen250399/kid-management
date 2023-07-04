import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kid_management/src/resources/colors.dart';
import 'package:kid_management/src/ui/common-ui/custom_switch.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ScreenLockingScreen extends StatefulWidget {
  @override
  _ScreenLockingScreenState createState() => _ScreenLockingScreenState();
}

class _ScreenLockingScreenState extends State<ScreenLockingScreen> {
  bool _lockDeviceTimer = true;
  bool _unlockDeviceTimer = true;
  String _lockTimeMode = 'pm';
  String _lockTime = '12';
  String _unlockTimeMode = 'am';
  String _unlockTime = '8';

  Timer _timer;

  int _totalMinutes;
  int _currentMinutes;
  double _percent;

  List<DropdownMenuItem> _buildDropdownMenuItems() {
    List<DropdownMenuItem> items = [];

    for (int i = 1; i <= 12; i++) {
      DropdownMenuItem item = DropdownMenuItem(
        child: Text('${i}:00', style: TextStyle(fontWeight: FontWeight.bold)),
        value: '${i}',
      );
      items.add(item);
    }

    return items;
  }

  void _startTimer() {
    // _totalMinutes =
    _timer = Timer.periodic(Duration(seconds: 60), (timer) {
        setState(() {
          _currentMinutes--;
          if(_currentMinutes <= 0){
            _currentMinutes = _totalMinutes;
          }
          _percent = 1.0 - (_currentMinutes / _totalMinutes);
        });
        print('current mins: $_currentMinutes, percent: $_percent');
    });
  }

  String _durationToString(int minutes) {
    var d = Duration(minutes:minutes);
    List<String> parts = d.toString().split(':');
    return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
  }

  int _calculateMinutes(){
    String time = _lockTime;
    String timeMode = _lockTimeMode;
    int hour = timeMode == 'am'
        ? int.parse(time)
        : int.parse(time) + 12;
    String hourString =
    hour.toString().length <= 1 ? '0$hour' : hour.toString();
    var now = DateTime.now();
    String s = now.toString().split(' ')[0] +
        ' $hourString:00:00';

    var pickedDate = DateTime.parse(s);

    var currentHour = now.hour;
    print('picked hour: $hour, cur hour: $currentHour');
    if (hour < currentHour) {
      // set to new date
      var nextDay = pickedDate.add(Duration(days: 1));
      print('next day: ${nextDay.toString()}');
      var duration = nextDay.difference(now);
      return duration.inMinutes;
    } else {
      var duration = pickedDate.difference(now);
      return duration.inMinutes;
    }
  }

  @override
  void initState() {
    super.initState();
    _totalMinutes = _calculateMinutes();
    _currentMinutes = _totalMinutes;
    _percent = 1.0 - (_currentMinutes / _totalMinutes);
    print('init state: percent = $_percent');
    print('Starting timer...');
    _startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer.isActive) {
      _timer.cancel();
      print("timer canceled...");
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Container(
          height: size.height,
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              SizedBox(
                height: 50.0,
              ),
              Visibility(
                child: Column(
                  children: [
                    Container(
                      child: Text('The device will be blocked in', style: TextStyle(color: AppColor.grayDark),),
                      margin: EdgeInsets.only(bottom: 20.0),
                    ),
                    CircularPercentIndicator(
                      percent: _percent,
                      radius: 200.0,
                      backgroundColor: AppColor.grayLight,
                      progressColor: AppColor.mainColor,
                      lineWidth: 20.0,
                      animation: true,
                      animateFromLastPercent: true,
                      center: Text(
                        '${_durationToString(_currentMinutes)}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22.0),
                      ),
                    ),
                  ],
                ),
                visible: _lockDeviceTimer,
              ),
              Visibility(
                child: SizedBox(
                  height: 30.0,
                ),
                visible: _lockDeviceTimer,
              ),
              // lock device section
              Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Text(
                            'locking'.toUpperCase(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),
                        ),
                        Icon(
                          Icons.lock,
                          color: AppColor.mainColor,
                          size: 22.0,
                        )
                      ],
                      crossAxisAlignment: CrossAxisAlignment.center,
                    ),
                    Row(
                      children: [
                        Text("Set time to lock device"),
                        Spacer(),
                        CustomSwitch(
                          value: _lockDeviceTimer,
                          onChanged: (value) {
                            setState(() {
                              _lockDeviceTimer = value;
                            });

                            if (value) {

                            }
                          },
                        )
                      ],
                    ),
                    Visibility(
                      visible: _lockDeviceTimer,
                      child: Row(
                        children: [
                          Text('Lock my device at'),
                          Spacer(),
                          DropdownButton(
                            items: _buildDropdownMenuItems(),
                            onChanged: (value) {
                              setState(() {
                                _lockTime = value;
                                _totalMinutes = _calculateMinutes();
                                _currentMinutes = _totalMinutes;
                                _percent = 1.0 - (_currentMinutes / _totalMinutes);
                              });
                            },
                            value: _lockTime,
                            icon: Icon(Icons.keyboard_arrow_down),
                          ),
                          DropdownButton(
                            items: [
                              DropdownMenuItem(
                                child: Text(
                                  'AM',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                value: 'am',
                              ),
                              DropdownMenuItem(
                                child: Text('PM',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                value: 'pm',
                              )
                            ],
                            onChanged: (value) {
                              setState(() {
                                _lockTimeMode = value;
                                _totalMinutes = _calculateMinutes();
                                _currentMinutes = _totalMinutes;
                                _percent = 1.0 - (_currentMinutes / _totalMinutes);
                              });
                            },
                            value: _lockTimeMode,
                            icon: Icon(Icons.keyboard_arrow_down),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Text(
                            'unlocking'.toUpperCase(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),
                        ),
                        Icon(
                          Icons.lock_open,
                          color: AppColor.mainColor,
                          size: 22.0,
                        )
                      ],
                      crossAxisAlignment: CrossAxisAlignment.center,
                    ),
                    Row(
                      children: [
                        Text("Set time to unlock device"),
                        Spacer(),
                        CustomSwitch(
                          value: _unlockDeviceTimer,
                          onChanged: (value) {
                            setState(() {
                              _unlockDeviceTimer = value;
                            });
                          },
                        )
                      ],
                    ),
                    Visibility(
                      visible: _unlockDeviceTimer,
                      child: Row(
                        children: [
                          Text('Unlock my device at'),
                          Spacer(),
                          DropdownButton(
                            items: _buildDropdownMenuItems(),
                            onChanged: (value) {
                              setState(() {
                                _unlockTime = value;
                              });
                            },
                            value: _unlockTime,
                            icon: Icon(Icons.keyboard_arrow_down),
                          ),
                          DropdownButton(
                            items: [
                              DropdownMenuItem(
                                child: Text(
                                  'AM',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                value: 'am',
                              ),
                              DropdownMenuItem(
                                child: Text('PM',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                value: 'pm',
                              )
                            ],
                            onChanged: (value) {
                              setState(() {
                                _unlockTimeMode = value;
                              });
                            },
                            value: _unlockTimeMode,
                            icon: Icon(Icons.keyboard_arrow_down),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}

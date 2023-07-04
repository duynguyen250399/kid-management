import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kid_management/src/resources/colors.dart';
import 'package:kid_management/src/ui/device-control/brightness_slider.dart';

class BrightnessControlScreen extends StatefulWidget {
  @override
  _BrightnessControlScreenState createState() =>
      _BrightnessControlScreenState();
}

class _BrightnessControlScreenState extends State<BrightnessControlScreen> {
  bool _isBrightnessWarningOn = true;
  bool _isEyesProtectionModeOn = true;
  bool _isCustomizeBrightnessOn = false;
  double _morningBrightness = 50.0;
  double _afternoonBrightness = 100.0;
  double _nightBrightness = 0;

  // build text widget represents status of brightness
  Widget _buildStatus(double brightness) {
    String statusText = '';
    Color textColor;
    if (brightness < 1) {
      statusText = 'Low';
      textColor = AppColor.grayDark;
    } else if (brightness <= 50) {
      statusText = 'Medium';
      textColor = Color(0xff463AB0);
    } else {
      statusText = 'Upper-medium';
      textColor = Color(0xffB03A69);
    }

    return Text(
      statusText,
      style: TextStyle(color: textColor, fontSize: 10.0, fontWeight: FontWeight.bold),
    );
  }
  
  double _processBrightnessValue(double value){
    // process value of slider to divide it into 3 levels
    // low level: value 0-1
    // medium level: value 1-50
    // upper-medium level: value 51-100
    if (value < 1) {
      return 0;
    }
    if (value >= 1.0 && value <= 50) {
      return 50;
    }
    if (value > 50 && value <= 100) {
      return 100;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      width: size.width,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Opacity(
              opacity: 0.7,
              child: SvgPicture.asset(
                'assets/images/device-control/brightness_control.svg',
                width: 150.0,
              ),
            ),
          ),
          SizedBox(height: 10.0,),
          Text(
            'Smart brightness control for your device',
            style: TextStyle(color: AppColor.grayDark),
          ),
          Container(
            margin: EdgeInsets.only(top: 20.0),
            child: Row(
              children: [
                SizedBox(
                  child: Text(
                      'Warning your kid when they turn the brightness too high'),
                  width: size.width * 0.7,
                ),
                Spacer(),
                MySwitch(
                  value: _isBrightnessWarningOn,
                  onChanged: (value) {
                    setState(() {
                      _isBrightnessWarningOn = value;
                    });
                  },
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20.0),
            child: Row(
              children: [
                SizedBox(
                  child: Text(
                      "Auto adjusting brightness to protect your kid's eyes"),
                  width: size.width * 0.7,
                ),
                Spacer(),
                MySwitch(
                  value: _isEyesProtectionModeOn,
                  onChanged: (value) {
                    setState(() {
                      _isEyesProtectionModeOn = value;
                      if (_isEyesProtectionModeOn) {
                        _isCustomizeBrightnessOn = false;
                      } else {
                        _isCustomizeBrightnessOn = true;
                      }
                    });
                  },
                )
              ],
            ),
          ),
          // Customize brightness section
          Visibility(
              visible: _isCustomizeBrightnessOn,
              child: Column(
                children: [
                  // customize the brightness of morning
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            SvgPicture.asset(
                              'assets/images/device-control/brightness.svg',
                              width: 20.0,
                              color: AppColor.grayDark,
                            )
                          ],
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Morning',
                              ),
                              Text('(6 AM - 11 AM)', style: TextStyle(color: AppColor.grayDark)),
                              // brightness status
                              _buildStatus(_morningBrightness)
                            ]),
                        Spacer(),
                        BrightnessSlider(
                          value: _morningBrightness,
                          onChanged: (value) {
                            setState(() {
                              _morningBrightness = _processBrightnessValue(value);
                            });
                          },
                        )
                      ],
                    ),
                  ),

                  // customize brightness for the afternoon
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            SvgPicture.asset(
                              'assets/images/device-control/brightness.svg',
                              width: 20.0,
                              color: AppColor.grayDark,
                            )
                          ],
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Afternoon',
                              ),
                              Text('(11 AM - 6 PM)', style: TextStyle(color: AppColor.grayDark)),
                              // brightness status
                              _buildStatus(_afternoonBrightness)
                            ]),
                        Spacer(),
                        BrightnessSlider(
                          value: _afternoonBrightness,
                          onChanged: (value) {
                            setState(() {
                              _afternoonBrightness = _processBrightnessValue(value);
                            });
                          },
                        )
                      ],
                    ),
                  ),

                  // customize brightness for the evening and night
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            SvgPicture.asset(
                              'assets/images/device-control/brightness.svg',
                              width: 20.0,
                              color: AppColor.grayDark,
                            )
                          ],
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Evening & Night',
                              ),
                              Text('(6 PM - 11 PM)', style: TextStyle(color: AppColor.grayDark)),
                              // brightness status
                              _buildStatus(_nightBrightness)
                            ]),
                        Spacer(),
                        BrightnessSlider(
                          value: _nightBrightness,
                          onChanged: (value) {
                            setState(() {
                              _nightBrightness = _processBrightnessValue(value);
                            });
                          },
                        )
                      ],
                    ),
                  )
                ],
              ))
        ],
      ),
    );
  }
}

class MySwitch extends StatefulWidget {
  bool value;
  Function onChanged;

  MySwitch({this.value, this.onChanged});

  @override
  _MySwitchState createState() => _MySwitchState();
}

class _MySwitchState extends State<MySwitch> {
  @override
  Widget build(BuildContext context) {
    return Switch(
      value: widget.value,
      onChanged: widget.onChanged,
      activeColor: AppColor.mainColor,
    );
  }
}



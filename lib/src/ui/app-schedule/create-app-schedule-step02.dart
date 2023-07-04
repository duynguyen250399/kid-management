import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kid_management/src/fake-data/fake_data.dart';
import 'package:kid_management/src/models/app_schedule.dart';
import 'package:kid_management/src/models/app_time_period.dart';
import 'package:kid_management/src/resources/colors.dart';
import 'package:kid_management/src/resources/constant.dart';
import 'package:kid_management/src/ui/app-schedule/app-checkbox-list.dart';
import 'package:kid_management/src/ui/app-schedule/create-app-schedule-step03.dart';
import 'package:kid_management/src/ui/common-ui/back-button.dart';

class CreateAppScheduleStep02 extends StatefulWidget {
  AppScheduleModel appScheduleModel;

  CreateAppScheduleStep02({this.appScheduleModel});

  @override
  _CreateAppScheduleStep02State createState() =>
      _CreateAppScheduleStep02State();
}

class _CreateAppScheduleStep02State extends State<CreateAppScheduleStep02> {
  bool isButtonDisabled = false;
  final String BUTTON_TEXT = 'DONE';
  final String APPBAR_TITLE = 'CREATE SCHEDULE';
  final String HEAD_TITLE = 'I WANT MY KID TO USE APPS';
  final String SUB_TITLE = "Now, let's limit a period of time for usage";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          APPBAR_TITLE,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 24.0, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            bottom: 100.0,
            right: 10.0,
            // background svg
            child: Opacity(
              opacity: 0.3,
              child: SvgPicture.asset(
                URL_IMG_BG_APP_SCHEDULE_STEP03,
                width: 120.0,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // current step text
              Text(
                '2/3',
                style: TextStyle(color: AppColor.mainColor, fontSize: 20.0),
              ),
              SizedBox(
                height: 25.0,
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(HEAD_TITLE,
                  style:
                      TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600)),
              SizedBox(
                height: 10.0,
              ),
              Text(SUB_TITLE,
                  style: TextStyle(fontSize: 16.0, color: AppColor.grayDark)),
              SizedBox(
                height: 20.0,
              ),
              TimePeriodPicker(),
              Spacer(),
              // the 'NEXT' button
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                margin: EdgeInsets.only(bottom: 20.0),
                width: double.infinity,
                height: 50.0,
                child: RaisedButton(
                  disabledColor: AppColor.mainColor.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0)),
                  elevation: 2.0,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateAppScheduleStep03(
                            appScheduleModel: widget.appScheduleModel,
                          ),
                        )).then((value) {
                      if (value == 'success') {
                        Navigator.pop(context, 'success');
                      }
                    });
                  },
                  color: AppColor.mainColor,
                  child: Text(
                    'NEXT',
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kid_management/src/models/app_schedule.dart';
import 'package:kid_management/src/resources/colors.dart';
import 'package:kid_management/src/resources/constant.dart' as CONSTANT;
import 'package:kid_management/src/ui/app-schedule/create-app-schedule-step02.dart';
import 'package:kid_management/src/ui/common-ui/back-button.dart';

class CreateAppScheduleStep01 extends StatefulWidget {
  AppScheduleModel appScheduleModel;
  CreateAppScheduleStep01({this.appScheduleModel});

  @override
  _CreateAppScheduleStep01State createState() =>
      _CreateAppScheduleStep01State();
}

class _CreateAppScheduleStep01State extends State<CreateAppScheduleStep01> {
  bool isButtonDisabled = true;

  final String BUTTON_TEXT = 'NEXT';
  final String APPBAR_TITLE = 'CREATE SCHEDULE';
  final String HEAD_TITLE = 'NAME YOUR SCHEDULE';
  final String SUB_TITLE = "This will help you easily remember";
  final String HINT_TEXT = "SCHEDULE'S NAME";

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
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // current step text
            Text(
              '1/3',
              style: TextStyle(color: AppColor.mainColor, fontSize: 20.0),
            ),
            SizedBox(
              height: 25.0,
            ),
            // background svg
            Opacity(
              opacity: 0.3,
              child: SvgPicture.asset(
                CONSTANT.URL_IMG_BG_APP_SCHEDULE_STEP01,
                width: 150.0,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(HEAD_TITLE,
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600)),
            SizedBox(
              height: 10.0,
            ),
            Text(SUB_TITLE,
                style: TextStyle(fontSize: 16.0, color: AppColor.grayDark)),
            SizedBox(
              height: 20.0,
            ),
            // text field to input schedule's name
            TextField(
              onChanged: (value) {
                widget.appScheduleModel.name = value;

                setState(() {
                  if (value.length == 0) {
                    this.isButtonDisabled = true;
                  } else {
                    this.isButtonDisabled = false;
                  }
                });
              },
              enableSuggestions: false,
              autocorrect: false,
              style: TextStyle(fontSize: 26.0),
              textInputAction: TextInputAction.next,
              onSubmitted: (value) {
                if (value.length > 0) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateAppScheduleStep02(
                          appScheduleModel: widget.appScheduleModel,
                        ),
                      )).then((value) {
                    if (value == 'success') {
                      Navigator.pop(context);
                    }
                  });
                }
              },
              autofocus: true,
              textAlign: TextAlign.center,
              textAlignVertical: TextAlignVertical.center,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                  hintText: HINT_TEXT,
                  hintStyle: TextStyle(fontSize: 18.0),
                  enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColor.mainColor, width: 1.0)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColor.mainColor, width: 2.0))),
            ),
            Spacer(),
            // the 'NEXT' button
            Container(
              margin: EdgeInsets.only(bottom: 20.0),
              width: double.infinity,
              height: 50.0,
              child: RaisedButton(
                disabledColor: AppColor.mainColor.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0)),
                elevation: 2.0,
                onPressed: this.isButtonDisabled
                    ? null
                    : () {
                        if (widget.appScheduleModel.name.isNotEmpty) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateAppScheduleStep02(
                                  appScheduleModel: widget.appScheduleModel,
                                ),
                              )).then((value) {
                            if (value == 'success') {
                              Navigator.pop(context);
                            }
                          });
                        }
                      },
                color: AppColor.mainColor,
                child: Text(
                  BUTTON_TEXT,
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

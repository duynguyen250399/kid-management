import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kid_management/src/resources/colors.dart';
import 'package:kid_management/src/ui/common-ui/back-button.dart';
import 'package:kid_management/src/ui/forgot-password/forgot_password_pin_code.dart';
import 'package:regexpattern/regexpattern.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool _isButtonDisabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 30.0,
              ),
              // title
              Center(
                child: Text(
                  "Don't worry!",
                  style: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 30.0, vertical: 10.0),
                child: Center(
                  child: Text(
                      "We'll help you reset password in just a simple step",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 16.0, color: AppColor.grayDark)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Opacity(
                    opacity: 0.5,
                    child: SvgPicture.asset(
                      'assets/images/forgot-password/bg.svg',
                      width: 100.0,
                    )),
              ),
              Container(
                height: 60.0,
                decoration: BoxDecoration(
                    color: AppColor.grayLight,
                    borderRadius: BorderRadius.circular(30.0)),
                child: Center(
                  child: TextField(
                    autofocus: true,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      if (value.length > 0 && value.isEmail()) {
                        setState(() {
                          _isButtonDisabled = false;
                        });
                      } else {
                        setState(() {
                          _isButtonDisabled = true;
                        });
                      }
                    },
                    textAlign: TextAlign.center,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: 'YOUR EMAIL'),
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.only(top: 20.0),
                width: double.infinity,
                height: 50.0,
                child: RaisedButton(
                  disabledColor: AppColor.mainColor.withOpacity(0.6),
                  color: AppColor.mainColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  onPressed: !_isButtonDisabled
                      ? () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForgotPasswordPinCode(),
                              ));
                        }
                      : null,
                  child: Text(
                    'get pin code'.toUpperCase(),
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kid_management/src/resources/colors.dart';
import 'package:kid_management/src/ui/common-ui/back-button.dart';
import 'package:kid_management/src/ui/forgot-password/reset_password.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ForgotPasswordPinCode extends StatefulWidget {
  @override
  _ForgotPasswordPinCodeState createState() => _ForgotPasswordPinCodeState();
}

class _ForgotPasswordPinCodeState extends State<ForgotPasswordPinCode> {
  String _currentPinCode = '';
  bool _isValidPinCode = false;
  Color _textFieldActiveColor = AppColor.mainColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 20.0),
              child: Center(
                  child: SvgPicture.asset(
                'assets/images/welcome_screen/kidspace_logo_filled.svg',
                width: 100.0,
              )),
            ),
            Text(
              'Please check your email to get PIN Code',
              style: TextStyle(
                  fontSize: 16.0,
                  color: AppColor.grayDark,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 100.0,
            ),
            Text(
              'Enter PIN Code'.toUpperCase(),
              style: TextStyle(fontSize: 20.0),
            ),
            // PIN code Text field
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
              child: PinCodeTextField(
                appContext: context,
                autoFocus: true,
                controller: TextEditingController(text: _currentPinCode),
                length: 6,
                onSubmitted: (value) {
                  if (_isValidPinCode) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResetPassword(),
                        ));
                  }
                },
                onChanged: (value) {
                  // set current pin code value every time user input a number
                  _currentPinCode = value;
                },
                onCompleted: (value) {
                  // automatically navigate to next screen if user types a valid pin code
                  if (_isValidPinCode) {
                    setState(() {
                      _textFieldActiveColor = AppColor.mainColor;
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResetPassword(),
                        ));
                  } else {
                    setState(() {
                      _textFieldActiveColor = Colors.redAccent;
                    });
                  }
                },
                validator: (value) {
                  _isValidPinCode = !value.contains(' ') &&
                      !value.contains('.') &&
                      !value.contains('-') &&
                      !value.contains(',');
                },
                textStyle:
                    TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                keyboardType: TextInputType.number,
                pinTheme: PinTheme(
                    borderWidth: 2.0,
                    activeColor: _textFieldActiveColor,
                    inactiveColor: AppColor.grayDark,
                    selectedColor: AppColor.mainColor),
              ),
            )
          ],
        ),
      ),
    );
  }
}

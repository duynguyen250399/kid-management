import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kid_management/src/fake-data/app_user_manager.dart';
import 'package:kid_management/src/resources/colors.dart';
import 'package:kid_management/src/ui/common-ui/back-button.dart';
import 'package:kid_management/src/ui/kid_app.dart';
import 'package:kid_management/src/ui/login.dart';
import 'package:kid_management/src/ui/master_page.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  String _username = AppUserManager.defaultUsername;
  String _oldPassword = '';
  String _newPassword = '';
  String _confirmPassword = '';
  // bool _isButtonDisabled = true;
  bool _isButtonDisabled = true;

  bool _isValidPassword(String password) {
    var regex = RegExp('^[a-zA-Z0-9]{6,}');
    return regex.hasMatch(password);
  }

  Future<bool> _isOldPassword() async {
    return await AppUserManager.login(_username, _oldPassword);
  }

  bool _isValidForm(String password, String confirmPassword) {
    return _isValidPassword(password) &&
        _isValidPassword(confirmPassword) &&
        password == confirmPassword;
  }

  bool _isPasswordMatch(String password, String confirmPassword) {
    return password == confirmPassword;
  }

  Widget _newPasswordField() {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      height: 60.0,
      decoration: BoxDecoration(
          color: AppColor.grayLight, borderRadius: BorderRadius.circular(30.0)),
      child: Center(
        child: TextField(
          onSubmitted: (value) {
            // bool isValid = _isValidForm(_newPassword, _confirmPassword);
            if (value.trim().isNotEmpty) {
            } else {
              Fluttertoast.showToast(
                  msg: 'Invalid!',
                  gravity: ToastGravity.CENTER,
                  backgroundColor: AppColor.grayDark,
                  textColor: Colors.white,
                  fontSize: 20.0);
            }
          },
          onChanged: (value) {
            _newPassword = value;
            // validate current new password value
            bool isValid = value.trim().isNotEmpty;
            setState(() {
              _isButtonDisabled = !isValid;
            });
          },
          autofocus: false,
          autocorrect: false,
          obscureText: true,
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
              hintText: 'NEW PASSWORD', border: InputBorder.none),
        ),
      ),
    );
  }

  Widget _oldPasswordField() {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      height: 60.0,
      decoration: BoxDecoration(
          color: AppColor.grayLight, borderRadius: BorderRadius.circular(30.0)),
      child: Center(
        child: TextField(
          onSubmitted: (value) async {
            bool isValid = await _isOldPassword();
            if (isValid) {
            } else {
              Fluttertoast.showToast(
                  msg: 'Old password is not true!',
                  gravity: ToastGravity.CENTER,
                  backgroundColor: AppColor.grayDark,
                  textColor: Colors.white,
                  fontSize: 20.0);
            }
          },
          onChanged: (value) async {
            _oldPassword = value;
            // validate current new password value
            bool isValid = await _isOldPassword();
            setState(() {
              _isButtonDisabled = !isValid;
            });
          },
          autofocus: false,
          autocorrect: false,
          obscureText: true,
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
              hintText: 'OLD PASSWORD', border: InputBorder.none),
        ),
      ),
    );
  }

  Widget _confirmPasswordField() {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      height: 60.0,
      decoration: BoxDecoration(
          color: AppColor.grayLight, borderRadius: BorderRadius.circular(30.0)),
      child: Center(
        child: TextField(
          onSubmitted: (value) {
            bool isValid = _isPasswordMatch(_newPassword, _confirmPassword);
            if (isValid) {
            } else {
              Fluttertoast.showToast(
                  msg: 'New Password not match!',
                  gravity: ToastGravity.CENTER,
                  backgroundColor: AppColor.grayDark,
                  textColor: Colors.white,
                  fontSize: 20.0);
            }
          },
          onChanged: (value) {
            _confirmPassword = value;
            // validate current confirm password value
            bool isValid = _isPasswordMatch(_newPassword, _confirmPassword);
            setState(() {
              _isButtonDisabled = !isValid;
            });
          },
          obscureText: true,
          autocorrect: false,
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
              hintText: 'CONFIRM PASSWORD', border: InputBorder.none),
        ),
      ),
    );
  }

  Widget _changePasswordButton() {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      width: double.infinity,
      height: 50.0,
      child: RaisedButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        disabledColor: AppColor.mainColor.withOpacity(0.6),
        color: AppColor.mainColor,
        onPressed: !_isButtonDisabled
            ? () async {
                bool checkLogin =
                    await AppUserManager.login(_username, _oldPassword);
                if (checkLogin) {
                  await AppUserManager.updatePassword(_newPassword);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ));
                }
              }
            : null,
        child: Text(
          'CHANGE PASSWORD',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context) {
        return new AlertDialog(
          title: Text(
            "We're almost done...",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Container(
            child: Text(
              "Are you sure to quit ?",
              textAlign: TextAlign.center,
            ),
          ),
          actionsPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          actions: [
            Row(
              children: [
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text(
                      'NO',
                      style: TextStyle(fontSize: 16.0, color: Colors.redAccent),
                    )),
                FlatButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => KidApp()),
                          (Route<dynamic> route) => route is KidApp);
                    },
                    child: Text(
                      'YES',
                      style:
                          TextStyle(fontSize: 16.0, color: AppColor.mainColor),
                    ))
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 50.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        "We're almost done!",
                        style: TextStyle(
                            fontSize: 30.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Center(
                      child: Text(
                        "Set new password and don't forget it!",
                        style:
                            TextStyle(fontSize: 16.0, color: AppColor.grayDark),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 50.0, bottom: 20.0),
                        child: SvgPicture.asset(
                            'assets/images/forgot-password/shield.svg')),
                    _oldPasswordField(),
                    _newPasswordField(),
                    _confirmPasswordField(),
                    _changePasswordButton()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kid_management/src/fake-data/app_user_manager.dart';
import 'package:kid_management/src/fake-data/fake_data.dart';
import 'package:kid_management/src/helpers/file_helper.dart';
import 'package:kid_management/src/resources/colors.dart';
import 'package:kid_management/src/resources/constant.dart' as CONSTANT;
import 'package:kid_management/src/ui/common-ui/back-button.dart';
import 'package:kid_management/src/ui/forgot-password/forgot_password.dart';
import 'package:kid_management/src/ui/kid_app.dart';
import 'package:kid_management/src/ui/master_page.dart';
import 'package:kid_management/src/ui/sign_up.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:kid_management/src/ui/forgot-password/reset_password.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final String _email_field = "Username";
  final String _password_field = "Password";
  FirebaseAuth auth = FirebaseAuth.instance;
  String _email, _password;
  @override
  void initState() {
    super.initState();
  }

  Future<void> signIn() async {
    final _formState = _formKey.currentState;
    // if (_formState.validate()) {
    _formState.save();
    try {
      // UserCredential _userCredential = await auth.signInWithEmailAndPassword(
      //     email: _email, password: _password);
      String sr = await rootBundle.loadString('assets/resources/config.json');
      var data = json.decode(sr);
      bool result = await AppUserManager.login(_email, _password);
      if (result) {
        FakeData.isLogin = true;
        // set login status
        Navigator.push(this.context,
            MaterialPageRoute(builder: (context) => MasterPage()));
      } else {
        _showErrorDialog("Login failed");
      }
    } catch (e) {
      _showErrorDialog(e.message);
    }
    // }
  }

  Widget _entryField(String title, String initvalue,
      {bool isPassword = false}) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Container(
            child: TextFormField(
                validator: (input) {
                  if (input.isEmpty && _email_field == title) {
                    return "PLease type a username!";
                  }
                  if (input.length < 6 && _password_field == title) {
                    return "Your password needs to be at least 6 characters!";
                  }
                  return null;
                },
                onSaved: (input) {
                  _email_field == title ? _email = input : _password = input;
                },
                initialValue: initvalue,
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.center,
                obscureText: isPassword,
                decoration: InputDecoration(
                    hintText: title,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        borderSide:
                            BorderSide(width: 0, style: BorderStyle.none)),
                    fillColor: Color(0xfff3f3f4),
                    filled: true)),
          )
        ],
      ),
    );
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () {
        signIn();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(35.0)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [HexColor("#3AB081"), HexColor("#349B72")])),
        child: Text(
          'LOGIN',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUp()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Don\'t have account?',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 15,
                color: const Color(0xff000000),
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Sign Up',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 15,
                color: const Color(0xff3dac43),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showErrorDialog(String msg) async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Login failed!'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(msg),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Widget _title() {
    return Column(
      children: <Widget>[
        Image.asset(
          CONSTANT.URL_IMG_USER_AVATAR,
          width: 126.0,
          height: 126.0,
        ),
        SizedBox(height: 20),
        Text(
          'WELCOME!',
          style: TextStyle(
            fontFamily: 'Segoe UI',
            fontSize: 20,
            color: const Color(0xff000000),
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.left,
        ),
        SizedBox(height: 10),
        Text(
          'Sign in to continue',
          style: TextStyle(
            fontFamily: 'Segoe UI',
            fontSize: 20,
            color: const Color(0xff888686),
          ),
          textAlign: TextAlign.left,
        ),
      ],
    );
  }

  Widget _emailPasswordWidget() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          _entryField(_email_field, "admin"),
          _entryField(_password_field, "admin", isPassword: true),
        ],
      ),
    );
  }

  Widget _forgotAccountLabel() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      alignment: Alignment.centerRight,
      child: Text(
        'Change Password?',
        style: TextStyle(
          fontFamily: 'Segoe UI',
          fontSize: 16,
          color: const Color(0xff3dac43),
          fontWeight: FontWeight.w700,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _title(),
                SizedBox(height: 50),
                _emailPasswordWidget(),
                InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ResetPassword()));
                    },
                    child: _forgotAccountLabel()),
                SizedBox(
                  height: 20.0,
                ),
                _submitButton(),
                // _createAccountLabel(),
              ],
            ),
          ),
        ));
  }
}

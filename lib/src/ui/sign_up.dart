import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kid_management/src/resources/colors.dart';
import 'package:kid_management/src/ui/common-ui/back-button.dart';
import 'package:kid_management/src/ui/login.dart';

import 'kid_app.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final String _name_field = "Name";
  final String _email_field = "Email";
  final String _password_field = "Password";
  FirebaseAuth auth = FirebaseAuth.instance;
  String _name, _email, _password;

  Future<void> signUp() async {
    final _formState = _formKey.currentState;
    if (_formState.validate()) {
      _formState.save();
      try {
        UserCredential _userCredential = await auth
            .createUserWithEmailAndPassword(email: _email, password: _password);
        var user = auth.currentUser;
        user.updateProfile(displayName: _name_field);
        Navigator.push(
            this.context, MaterialPageRoute(builder: (context) => LoginPage()));
      } catch (e) {
        print(e);
        _showErrorDialog(e.message);
      }
    }
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

  Widget _emailPasswordWidget() {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            _entryField(_name_field),
            _entryField(_email_field),
            _entryField(_password_field, isPassword: true),
          ],
        ));
  }

  Widget _entryField(String title, {bool isPassword = false}) {
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
                  if (input.isEmpty &&
                      (_email_field == title || _name_field == title)) {
                    return "This field can't be blank!";
                  }
                  if (input.length < 6 && _password_field == title) {
                    return "Your password needs to be at least 6 characters!";
                  }
                  return null;
                },
                onSaved: (input) {
                  if (_name_field == title) {
                    _name = input;
                  } else if (_email_field == title) {
                    _email = input;
                  } else {
                    _password = input;
                  }
                },
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

  Widget _title() {
    return Column(children: <Widget>[
      Container(
          margin: EdgeInsets.only(bottom: 20.0),
          child: SvgPicture.asset(
            'assets/images/welcome_screen/kidspace_logo_filled.svg',
            width: 150.0,
          )),
      Text("Let's get started with KidSpace",
          style: TextStyle(fontSize: 16.0, color: AppColor.grayDark))
    ]);
  }

  Widget _signUpButton() {
    return InkWell(
        onTap: () {
          signUp();
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30)),
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
            'CREATE ACCOUNT',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ));
  }

  Widget _signInLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Already have an account?',
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
              'Login',
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

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0
      ),
      body: new Container(
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _title(),
                    SizedBox(height: 20),
                    _emailPasswordWidget(),
                    SizedBox(height: 20),
                    _signUpButton(),
                    _signInLabel(),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

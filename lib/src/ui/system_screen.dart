import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kid_management/src/fake-data/SocketUtils.dart';
import 'package:kid_management/src/fake-data/fake_data.dart';
import 'package:kid_management/src/fake-data/global.dart';
import 'package:kid_management/src/resources/colors.dart';
import 'package:kid_management/src/resources/constant.dart' as CONSTANT;
import 'package:kid_management/src/ui/common-ui/back-button.dart';
import 'package:kid_management/src/ui/forgot-password/forgot_password.dart';
import 'package:kid_management/src/ui/kid_app.dart';
import 'package:kid_management/src/ui/master_page.dart';
import 'package:kid_management/src/ui/sign_up.dart';
import 'package:kid_management/src/ui/splash_screen.dart';

class SystemPage extends StatefulWidget {
  @override
  _SystemPageState createState() => _SystemPageState();
}

class _SystemPageState extends State<SystemPage> {
  final String _ip_address_field = "Ip Address";
  final String _kid_id_field = "Kid Id";
  final String _parent_id_field = "ParentId";
  String _ipAddress, _kidId, _parentId;
  @override
  void initState() {
    super.initState();
  }

  Future<void> apply() async {
    try {
      var kidId = int.parse(_kidId.trim());
      var parentId = int.parse(_parentId.trim());
      Global.kidId = kidId;
      Global.parentId = parentId;
      SocketUtils.ipAddress = _ipAddress;
      Navigator.push(
          this.context,
          MaterialPageRoute(
              builder: (context) => SplashScreen(
                    height: MediaQuery.of(context).size.height,
                  )));
    } catch (e) {}
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () {
        apply();
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
          'SYSTEM LOGIN',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _title() {
    return Column(
      children: <Widget>[
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
          'Add system information',
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
    return Column(
      children: <Widget>[
        TextField(
            onChanged: (value) => {_ipAddress = value},
            textAlign: TextAlign.start,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
                hintText: _ip_address_field,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    borderSide: BorderSide(width: 0, style: BorderStyle.none)),
                fillColor: Color(0xfff3f3f4),
                filled: true)),
        SizedBox(
          height: 10.0,
        ),
        TextField(
            onChanged: (value) => {_kidId = value},
            textAlign: TextAlign.start,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
                hintText: _kid_id_field,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    borderSide: BorderSide(width: 0, style: BorderStyle.none)),
                fillColor: Color(0xfff3f3f4),
                filled: true)),
        SizedBox(
          height: 10.0,
        ),
        TextField(
            onChanged: (value) => {_parentId = value},
            textAlign: TextAlign.start,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
                hintText: _parent_id_field,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    borderSide: BorderSide(width: 0, style: BorderStyle.none)),
                fillColor: Color(0xfff3f3f4),
                filled: true)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 50),
                _title(),
                SizedBox(height: 30),
                _emailPasswordWidget(),
                SizedBox(
                  height: 10.0,
                ),
                _submitButton(),
              ],
            ),
          ),
        ));
  }
}

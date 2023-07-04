import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kid_management/src/fake-data/fake_data.dart';
import 'package:kid_management/src/resources/constant.dart' as CONSTANT;
import 'package:kid_management/src/ui/master_page.dart';
import 'package:kid_management/src/ui/sign_up.dart';

import 'login.dart';

class KidApp extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<KidApp> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  Widget _signInButton() {
    return InkWell(
        onTap: () {
          if (FakeData.isLogin) {
            Navigator.push(this.context,
                MaterialPageRoute(builder: (context) => MasterPage()));
          } else {
            Navigator.push(this.context,
                MaterialPageRoute(builder: (context) => LoginPage()));
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xfffbb448), Color(0xfff7892b)])),
          child: Text(
            'SIGN IN',
            style: new TextStyle(color: Colors.white, fontSize: 20.0),
          ),
        ));
  }

  Widget _signUpButton() {
    return InkWell(
        onTap: () {
          Navigator.push(
              this.context, MaterialPageRoute(builder: (context) => SignUp()));
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: Colors.white,
          ),
          child: Text(
            'SIGN UP',
            style: new TextStyle(color: HexColor("#D59D47"), fontSize: 20.0),
          ),
        ));
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text(
            'OR',
            style: new TextStyle(color: Colors.white, fontSize: 15.0),
            textAlign: TextAlign.center,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(CONSTANT.URL_IMG_BACK_GROUND),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          children: <Widget>[
            SizedBox(height: 30.0),
            Column(
              children: <Widget>[
                Container(
                  child: SvgPicture.asset(
                      'assets/images/welcome_screen/kidspace_logo_white.svg'),
                  margin: EdgeInsets.symmetric(vertical: 20.0),
                ),
                Text(
                  'Let your kids in control',
                  style: new TextStyle(color: Colors.white, fontSize: 20.0),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 50.0),
              ],
            ),
            _signInButton(),
            _divider(),
            _signUpButton(),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

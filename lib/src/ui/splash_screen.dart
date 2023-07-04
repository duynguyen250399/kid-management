import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kid_management/src/fake-data/UserSocket.dart';
import 'package:kid_management/src/fake-data/fake_data.dart';
import 'package:kid_management/src/fake-data/global.dart';
import 'package:kid_management/src/models/app_schedule.dart';
import 'package:kid_management/src/ui/kid-screens/kid_control.dart';
import 'package:kid_management/src/ui/children_screens/children_screen.dart';
import 'package:kid_management/src/ui/kid_app.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:kid_management/src/resources/constant.dart' as CONSTANT;

class SplashScreen extends StatefulWidget {
  double height;

  SplashScreen({this.height});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _backgroundAnim;
  Animation<double> _logoAnim;
  Animation<double> _appNameAnim;
  Animation<double> _progressBarAnim;
  // bool _connectedToSocket;
  // String _errorConnectMessage;
  Color _mainColor = Color(0xff3ab081);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // controller to control all animations
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    _backgroundAnim = Tween<double>(begin: 0, end: widget.height).animate(
        CurvedAnimation(
            parent: _animationController,
            curve: Interval(0, 0.3, curve: Curves.linearToEaseOut)));

    _logoAnim = Tween<double>(begin: 0.1, end: 0.3).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.3, 0.5, curve: Curves.easeIn)));

    _appNameAnim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.5, 0.7, curve: Curves.easeInOut)));

    _progressBarAnim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.7, 1, curve: Curves.easeIn)));

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ChildrenScreen(),
            ));
      }
    });

    _animationController.forward();
  }

  Future<void> _showErrorDialog(String msg) async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedBuilder(
        animation: _backgroundAnim,
        builder: (context, child) {
          return Stack(
            children: [
              Container(
                width: size.width,
                height: _backgroundAnim.value,
                color: _mainColor,
              ),
              Positioned(
                left: 0,
                right: 0,
                top: size.height * _logoAnim.value,
                child: SvgPicture.asset('assets/images/splash_screen/icon.svg'),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: size.height * 0.57,
                child: Opacity(
                  opacity: _appNameAnim.value,
                  child: Text(
                    'Hello'.toUpperCase(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Positioned(
                child: Opacity(
                  opacity: _progressBarAnim.value,
                  child: LinearPercentIndicator(
                    percent: _progressBarAnim.value,
                    backgroundColor: Colors.white,
                    progressColor: Colors.amberAccent,
                    lineHeight: 20,
                    width: size.width * 0.5,
                    alignment: MainAxisAlignment.center,
                    linearStrokeCap: LinearStrokeCap.roundAll,
                    animateFromLastPercent: true,
                  ),
                ),
                left: 0,
                right: 0,
                top: size.height * 0.8,
              )
            ],
          );
        },
      ),
    );
  }
}

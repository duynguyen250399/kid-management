import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kid_management/src/resources/colors.dart';
import 'package:kid_management/src/ui/kid_app.dart';
import 'package:kid_management/src/ui/login.dart';

class ParentsModeScreen extends StatefulWidget {
  @override
  _ParentsModeScreenState createState() => _ParentsModeScreenState();
}

class _ParentsModeScreenState extends State<ParentsModeScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Stack(
      children: [
        // background image
        Positioned(
            top: size.height * 0.1,
            left: 0,
            right: 0,
            child: SvgPicture.asset(
              'assets/images/kid-screen/bg_parent_mode.svg',
              width: 300,
            )),
        Positioned(
          left: 0,
          right: 0,
          top: size.height * 0.45,
          child: Text(
            'switching to Setting mode'.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18.0),
          ),
        ),
        // Positioned(
        //   left: 0,
        //   right: 0,
        //   top: size.height * 0.5,
        //   child: Text(
        //     'now you can control your kid device'.toUpperCase(),
        //     textAlign: TextAlign.center,
        //     style: TextStyle(color: AppColor.grayDark),
        //   ),
        // ),
        Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: SizedBox(
              height: 50.0,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ));
                  // WidgetsBinding.instance.addPostFrameCallback((_) {
                  //   Navigator.pushReplacement(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => KidApp(),
                  //       ));
                  // });
                },
                color: AppColor.mainColor,
                child: Text(
                  'get started'.toUpperCase(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ))
      ],
    );
  }
}

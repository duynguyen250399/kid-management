import 'package:flutter/material.dart';
import 'package:kid_management/src/resources/colors.dart';
import 'package:kid_management/src/ui/common-ui/back-button.dart';
import 'package:kid_management/src/ui/device-control/bandwidth_control_screen.dart';
import 'package:kid_management/src/ui/device-control/brightness_control_screen.dart';
import 'package:kid_management/src/ui/device-control/screen_locking_screen.dart';

class DeviceControlScreen extends StatefulWidget {
  @override
  _DeviceControlScreenState createState() => _DeviceControlScreenState();
}

class _DeviceControlScreenState extends State<DeviceControlScreen> {
  int _selectedIndex = 0;
  PageController _pageController;
  List<Widget> _pages = [
    BrightnessControlScreen(),
    BandwidthControlScreen(),
    ScreenLockingScreen()
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'DEVICE CONTROL',
          style: TextStyle(
              fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        child: PageView.builder(
          itemBuilder: (context, index) {
            return _pages[index];
          },
          itemCount: _pages.length,
          controller: _pageController,
          onPageChanged: (value) {
            setState(() {
              _selectedIndex = value;
            });
          },
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: AppColor.mainColor.withOpacity(0.2),
              blurRadius: 10.0,
              offset: Offset(0, -3.0))
        ]),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: Container(
            child: BottomNavigationBar(
              iconSize: 40.0,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              onTap: (value) {
                setState(() {
                  _selectedIndex = value;
                  _pageController.animateToPage(_selectedIndex,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut);
                });
              },
              currentIndex: _selectedIndex,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.brightness_7,
                      color: AppColor.grayDark,
                    ),
                    label: '',
                    activeIcon: Icon(
                      Icons.brightness_7,
                      color: AppColor.mainColor,
                    )),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.speed,
                      color: AppColor.grayDark,
                    ),
                    label: '',
                    activeIcon: Icon(
                      Icons.speed,
                      color: AppColor.mainColor,
                    )),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.screen_lock_portrait,
                      color: AppColor.grayDark,
                    ),
                    label: '',
                    activeIcon: Icon(
                      Icons.screen_lock_portrait,
                      color: AppColor.mainColor,
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

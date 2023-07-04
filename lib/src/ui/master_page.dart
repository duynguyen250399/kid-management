import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kid_management/src/fake-data/fake_data.dart';
import 'package:kid_management/src/models/user_information.dart';
import 'package:kid_management/src/resources/colors.dart';
import 'package:kid_management/src/ui/home_v2.dart';
import 'package:kid_management/src/ui/notification/notification.dart';
import 'package:kid_management/src/ui/user-profile/user_profile.dart';

class MasterPage extends StatefulWidget {
  @override
  _MasterPageState createState() => _MasterPageState();
}

// Master screen to navigate another screens using bottom nav bar
class _MasterPageState extends State<MasterPage> {
  FirebaseAuth auth;
  UserInformation user;
  List<Widget> _pages;
  // default selected index: 1, that mean default screen is HomePage()
  int _selectedIndex = 1;
  @override
  void initState() {
    super.initState();
    auth = FirebaseAuth.instance;
    // user = new UserInformation(auth.currentUser.displayName,
    //     auth.currentUser.email, auth.currentUser.phoneNumber);
    user = new UserInformation("admin", "admin", "");
    // List of all main screens to navigate
    _pages = [
      UserProfileScreen(user: user),
      Home2(user: user),
      NotificationScreen()
    ];
    FakeData.isChildMode = false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {},
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: _pages[_selectedIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          // hide label text of bottom nav bar
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
                activeIcon:
                    Icon(Icons.person, size: 35.0, color: AppColor.mainColor),
                icon: Icon(
                  Icons.person_outline,
                  size: 35.0,
                  color: AppColor.mainColor,
                ),
                title: Text('')),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_outlined,
                  size: 35.0,
                  color: AppColor.mainColor,
                ),
                activeIcon: Icon(
                  Icons.home,
                  size: 35.0,
                  color: AppColor.mainColor,
                ),
                title: Text('')),
            BottomNavigationBarItem(
                activeIcon: Stack(
                  children: [
                    Icon(
                      Icons.notifications,
                      size: 35.0,
                      color: AppColor.mainColor,
                    ),
                    Positioned(
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(2.0),
                          decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(8.0)),
                          child: Text(
                            FakeData.notifications.length.toString(),
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: Colors.white, fontSize: 10.0),
                          ),
                          constraints: BoxConstraints(
                              minWidth: 20.0, maxHeight: 20.0, maxWidth: 25.0),
                        ))
                  ],
                ),
                icon: Stack(
                  children: [
                    Icon(
                      Icons.notifications_none,
                      size: 35.0,
                      color: AppColor.mainColor,
                    ),
                    Positioned(
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(2.0),
                          decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(8.0)),
                          child: Text(
                            FakeData.notifications.length.toString(),
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: Colors.white, fontSize: 10.0),
                          ),
                          constraints: BoxConstraints(
                              minWidth: 20.0, maxHeight: 20.0, maxWidth: 25.0),
                        ))
                  ],
                ),
                title: Text(''))
          ],
          // switch selected index
          onTap: (value) {
            setState(() {
              _selectedIndex = value;
            });
          },
          currentIndex: _selectedIndex,
        ),
      ),
    );
  }
}

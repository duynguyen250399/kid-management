import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kid_management/src/fake-data/fake_data.dart';
import 'package:kid_management/src/models/location_history.dart';
import 'package:kid_management/src/resources/colors.dart';
import 'package:kid_management/src/ui/common-ui/back-button.dart';
import 'package:kid_management/src/ui/common-ui/custom_switch.dart';
import 'package:kid_management/src/ui/location-tracking/location_history_list.dart';

class LocationTrackingScreen extends StatefulWidget {
  List<LocationHistory> recentLocationHistories;

  @override
  _LocationTrackingScreenState createState() => _LocationTrackingScreenState();
}

class _LocationTrackingScreenState extends State<LocationTrackingScreen> {
  bool _searchBarIsShow = false;
  bool _locationTrackingIsOn = true;
  bool _allowKidTurnOffGPS = false;
  String _currentDistanceLimit = '3';
  FocusNode _searchBarFocusNode;

  List<DropdownMenuItem> _buildDistanceDropdownItems() {
    return [
      DropdownMenuItem(
        child: Text('< 3 km'),
        value: '3',
      ),
      DropdownMenuItem(
        child: Text('< 6 km'),
        value: '6',
      ),
      DropdownMenuItem(
        child: Text('< 10 km'),
        value: '10',
      ),
      DropdownMenuItem(
        child: Text('< 15 km'),
        value: '15',
      ),
    ];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchBarFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    widget.recentLocationHistories = FakeData.recentLocationHistories();
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'LOCATION TRACKING',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 22.0, color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          CustomSwitch(
            value: _locationTrackingIsOn,
            onChanged: (value) {
              setState(() {
                _locationTrackingIsOn = value;
              });
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            children: [
              SvgPicture.asset(
                  'assets/images/location-tracking/bg_location.svg'),
              SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  Icon(
                    Icons.gps_fixed,
                    color: AppColor.mainColor,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text('Allow kid to turn off GPS'.toUpperCase()),
                  Spacer(),
                  CustomSwitch(
                    value: _allowKidTurnOffGPS,
                    onChanged: (value) {
                      setState(() {
                        _allowKidTurnOffGPS = value;
                      });
                    },
                  )
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.run_circle,
                    color: AppColor.mainColor,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    'Record location history\nwhen the kid moved'.toUpperCase(),
                  ),
                  Spacer(),
                  DropdownButton(
                    items: _buildDistanceDropdownItems(),
                    onChanged: (value) {
                      setState(() {
                        _currentDistanceLimit = value;
                      });
                    },
                    value: _currentDistanceLimit,
                  )
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  !_searchBarIsShow
                      ? Text(
                          'LOCATION HISTORY',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.0),
                        )
                      : Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                color: AppColor.grayLight,
                                borderRadius: BorderRadius.circular(30.0)),
                            child: TextField(
                              focusNode: _searchBarFocusNode,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                hintText: 'Search location history',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                  Visibility(
                    child: Spacer(),
                    visible: !_searchBarIsShow,
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.search,
                        color: AppColor.mainColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _searchBarIsShow = !_searchBarIsShow;
                          _searchBarFocusNode.requestFocus();
                        });
                      }),
                  // filter button
                  FilterPopupButton()
                ],
              ),
              LocationHistoryList(
                locationHistories: widget.recentLocationHistories,
                headTitle: 'RECENT DAYS',
              ),
              LocationHistoryList(
                locationHistories: widget.recentLocationHistories,
                headTitle: 'PREVIOUS DAYS',
              ),
              Container(
                margin: EdgeInsets.only(top: 30.0, bottom: 10.0),
                width: double.infinity,
                height: 50.0,
                child: RaisedButton(
                  elevation: 0,
                  onPressed: () {},
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Colors.redAccent)),
                  color: Colors.white,
                  child: Text(
                    'CLEAR HISTORY',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class FilterPopupButton extends StatefulWidget {
  @override
  _FilterPopupButtonState createState() => _FilterPopupButtonState();
}

class _FilterPopupButtonState extends State<FilterPopupButton> {
  String _currentHistoryFilter = 'days';
  final String dayFilter = 'days';
  final String weekFilter = 'weeks';

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onCanceled: () {
        print('cancel');
      },
      child: Icon(
        Icons.filter_alt_rounded,
        color: AppColor.mainColor,
      ),
      onSelected: (value) {
        setState(() {
          var filterValue = value == 1 ? dayFilter : weekFilter;
          _currentHistoryFilter = filterValue;
        });
      },
      initialValue: 1,
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            child: RadioListTile(
              title: Text('Days'),
              activeColor: AppColor.mainColor,
              value: dayFilter,
              groupValue: _currentHistoryFilter,
            ),
            value: 1,
          ),
          PopupMenuItem(
            child: RadioListTile(
              title: Text('Weeks'),
              value: weekFilter,
              groupValue: _currentHistoryFilter,
              activeColor: AppColor.mainColor,
            ),
            value: 2,
          ),
        ];
      },
    );
  }
}

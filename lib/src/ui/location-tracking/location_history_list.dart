import 'package:flutter/material.dart';
import 'package:kid_management/src/models/location_history.dart';
import 'package:kid_management/src/ui/location-tracking/location_history_item.dart';

class LocationHistoryList extends StatefulWidget {
  List<LocationHistory> locationHistories;
  String headTitle;

  LocationHistoryList({this.headTitle, this.locationHistories});

  @override
  _LocationHistoryListState createState() => _LocationHistoryListState();
}

class _LocationHistoryListState extends State<LocationHistoryList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 40.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                widget.headTitle,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.0),
              ),
            ],
          ),
          SingleChildScrollView(
            child: Column(
                children: widget.locationHistories
                    .map((locationHistory) => LocationHistoryItem(
                          locationHistory: locationHistory,
                        ))
                    .toList()),
          )
        ],
      ),
    );
  }
}

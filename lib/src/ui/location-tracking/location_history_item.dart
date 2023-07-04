import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kid_management/src/models/location_history.dart';
import 'package:kid_management/src/resources/colors.dart';
import 'package:kid_management/src/ui/location-tracking/address_history_card.dart';

class LocationHistoryItem extends StatefulWidget {
  LocationHistory locationHistory;

  LocationHistoryItem({this.locationHistory});

  @override
  _LocationHistoryItemState createState() => _LocationHistoryItemState();
}

class _LocationHistoryItemState extends State<LocationHistoryItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.date_range,
                color: AppColor.mainColor,
              ),
              Text(
                widget.locationHistory.date,
                style: TextStyle(
                    color: AppColor.mainColor, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Column(
            children: widget.locationHistory.addressHistories
                .map((addressHistory) => AddressHistoryCard(
                      addressHistory: addressHistory,
                    ))
                .toList(),
          )
        ],
      ),
    );
  }
}

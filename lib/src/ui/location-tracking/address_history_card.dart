import 'package:flutter/material.dart';
import 'package:kid_management/src/models/address_history.dart';
import 'package:kid_management/src/resources/colors.dart';

class AddressHistoryCard extends StatefulWidget {
  AddressHistory addressHistory;

  AddressHistoryCard({this.addressHistory});

  @override
  _LocationHistoryItemState createState() => _LocationHistoryItemState();
}

class _LocationHistoryItemState extends State<AddressHistoryCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        margin: EdgeInsets.only(top: 5.0),
        decoration: BoxDecoration(
            color: AppColor.grayLight,
            borderRadius: BorderRadius.circular(5.0)),
        child: Row(
          children: [
            Icon(
              Icons.location_on,
              color: Colors.red,
            ),
            SizedBox(
              width: 5.0,
            ),
            SingleChildScrollView(
              child: Text(widget.addressHistory.address),
              scrollDirection: Axis.horizontal,
            ),
            Spacer(),
            Text(
              widget.addressHistory.time,
              style: TextStyle(color: AppColor.mainColor),
            )
          ],
        ),
      ),
    );
  }
}

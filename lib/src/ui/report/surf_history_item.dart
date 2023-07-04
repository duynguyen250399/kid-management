import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kid_management/src/models/my_app.dart';
import 'package:kid_management/src/resources/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class SurfHistoryItem extends StatefulWidget {
  String url;
  String time;
  String date;

  SurfHistoryItem({this.url, this.time, this.date});

  @override
  _SurfHistoryItemState createState() => _SurfHistoryItemState();
}

class _SurfHistoryItemState extends State<SurfHistoryItem> {

  void _openUrl(String url) async{
    print("openning url...");
    if (await canLaunch(url)) {
    await launch(url);
    } else {
    throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _openUrl(widget.url);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        decoration: BoxDecoration(
          color: AppColor.grayLight,
          borderRadius: BorderRadius.circular(10.0),
        ),
        margin: EdgeInsets.only(top: 5.0),
        child: Column(
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  'assets/images/report/chrome.svg',
                  width: 30.0,
                  color: AppColor.mainColor,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(widget.url),
                    scrollDirection: Axis.horizontal,
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(widget.time, style: TextStyle(color: AppColor.grayDark, fontSize: 12.0)),
                SizedBox(
                  width: 10.0,
                ),
                Text(widget.date, style: TextStyle(color: AppColor.grayDark, fontSize: 12.0))
              ],
            )
          ],
        ),
      ),
    );
  }
}

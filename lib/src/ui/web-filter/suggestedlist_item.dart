import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kid_management/src/models/blacklist_item_model.dart';
import 'package:kid_management/src/models/suggested_item_model.dart';
import 'package:kid_management/src/resources/colors.dart';

class SuggestedSiteItem extends StatefulWidget {
  SuggestedItemModel suggestedItemModel;
  Function onDelete;

  SuggestedSiteItem({this.suggestedItemModel, this.onDelete});

  @override
  _BlacklistSiteItemState createState() => _BlacklistSiteItemState();
}

class _BlacklistSiteItemState extends State<SuggestedSiteItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      margin: EdgeInsets.only(top: 3.0),
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
          color: AppColor.grayLight, borderRadius: BorderRadius.circular(4.0)),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/images/web-filter/global.svg',
            width: 16.0,
            color: AppColor.mainColor,
          ),
          SizedBox(
            width: 10.0,
          ),
          Text(
            widget.suggestedItemModel.url,
            style: TextStyle(color: AppColor.mainColor),
          ),
          Spacer(),
          // button to remove current url in blacklist
          GestureDetector(
            child: Icon(
              Icons.clear_outlined,
              size: 16.0,
            ),
            onTap: widget.onDelete,
          )
        ],
      ),
    );
  }
}

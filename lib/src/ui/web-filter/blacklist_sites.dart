import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kid_management/src/fake-data/fake_data.dart';
import 'package:kid_management/src/models/blacklist_item_model.dart';
import 'package:kid_management/src/resources/colors.dart';
import 'package:kid_management/src/ui/web-filter/blacklist_item.dart';

class BlacklistSites extends StatefulWidget {
  List<BlacklistItemModel> blacklistItems;

  BlacklistSites({this.blacklistItems});

  @override
  _BlacklistSitesState createState() => _BlacklistSitesState();
}

class _BlacklistSitesState extends State<BlacklistSites> {
  bool _blacklistNotifyOn = true;
  bool _isCollaped = true;

  @override
  Widget build(BuildContext context) {
    int _listLimit = 3;
    int _allSize = widget.blacklistItems.length;

    return Column(
      children: [
        Row(
          children: [
            Text('blacklist sites'.toUpperCase(),
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0)),
            // button to add a site to blacklist
            Container(
              margin: EdgeInsets.only(left: 10.0),
              child: ClipOval(
                child: Material(
                  color: AppColor.mainColor, // button color
                  child: InkWell(
                    splashColor: Colors.redAccent, // inkwell color
                    child: SizedBox(
                        width: 26,
                        height: 26,
                        child: Icon(
                          Icons.add,
                          size: 16.0,
                          color: Colors.white,
                        )),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                              actions: [
                                FlatButton(
                                  onPressed: () {},
                                  child: Text('OK', style: TextStyle(color: AppColor.mainColor)),
                                ),
                                FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: Text('CANCEL', style: TextStyle(color: AppColor.mainColor),),
                                )
                              ],
                              title: Center(child: Text('Add new site')),
                              content: TextField(
                                autofocus: true,
                                decoration: InputDecoration(
                                    hintText: 'Example: google.com'),
                              ));
                        },
                      );
                    },
                  ),
                ),
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            children: [
              Text(
                'Prevent your kid from accessing some websites',
                style: TextStyle(color: AppColor.grayDark, fontSize: 12.0),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Notify me when my kid try to \naccess blacklist sites',
                style: TextStyle(fontSize: 14.0)),
            // switch to toggle on or off blacklist access notification
            Switch(
              value: _blacklistNotifyOn,
              onChanged: (value) {
                setState(() {
                  _blacklistNotifyOn = value;
                });
              },
              activeColor: AppColor.mainColor,
            )
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        widget.blacklistItems.length > 0
            ? Column(
                // limit the list of items to be shown
                children: widget.blacklistItems
                    .sublist(
                        0,
                        _isCollaped && widget.blacklistItems.length > 3
                            ? _listLimit
                            : _allSize)
                    .map((item) => BlacklistSiteItem(
                          blackListItemModel: item,
                          onDelete: () {
                            setState(() {
                              widget.blacklistItems.remove(item);
                            });
                          },
                        ))
                    .toList(),
              )
            : Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                decoration: BoxDecoration(
                    color: AppColor.grayLight,
                    borderRadius: BorderRadius.circular(4.0)),
                child: Center(
                  child: Text("There's no site in blacklist"),
                ),
              ),
        SizedBox(
          height: 6.0,
        ),
        Visibility(
          visible: _isCollaped && widget.blacklistItems.length > 3,
          child: GestureDetector(
            // view all blacklist items
            onTap: () {
              setState(() {
                widget.blacklistItems = FakeData.blacklistItems();
                _isCollaped = false;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'View more',
                  style: TextStyle(color: AppColor.mainColor),
                ),
                Icon(Icons.keyboard_arrow_down_outlined,
                    color: AppColor.mainColor)
              ],
            ),
          ),
        )
      ],
    );
  }
}

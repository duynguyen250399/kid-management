
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kid_management/src/fake-data/fake_data.dart';
import 'package:kid_management/src/models/blacklist_item_model.dart';
import 'package:kid_management/src/models/suggested_item_model.dart';
import 'package:kid_management/src/resources/colors.dart';
import 'package:kid_management/src/ui/common-ui/back-button.dart';
import 'package:kid_management/src/ui/web-filter/blacklist_sites.dart';
import 'package:kid_management/src/ui/web-filter/suggestion_sites.dart';

class WebFilterScreen extends StatefulWidget {
  @override
  _WebFilterScreenState createState() => _WebFilterScreenState();
}

class _WebFilterScreenState extends State<WebFilterScreen> {
  bool _webFilterIsOn = true;
  List<BlacklistItemModel> _blacklistItems = FakeData.blacklistItems();
  List<SuggestedItemModel> _suggestedItems = FakeData.suggestedItems();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'WEB FILTER',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 26.0, color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          Switch(
            value: _webFilterIsOn,
            onChanged: (value) {
              setState(() {
                _webFilterIsOn = value;
              });
            },
            activeColor: AppColor.mainColor,
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        width: size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: SvgPicture.asset(
                    'assets/images/web-filter/bg_web_filter.svg'),
              ),
              Text(
                'Help your kid surf the web in good purpose',
                style: TextStyle(color: AppColor.grayDark),
              ),
              SizedBox(
                height: 30.0,
              ),
              BlacklistSites(
                blacklistItems: _blacklistItems,
              ),
              SizedBox(
                height: 30.0,
              ),
              SuggestionSites(
                suggestedItems: _suggestedItems,
              ),
              SizedBox(height: 20.0,)
            ],
          ),
        ),
      ),
    );
  }
}

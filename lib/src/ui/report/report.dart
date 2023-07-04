import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kid_management/src/fake-data/fake_data.dart';
import 'package:kid_management/src/resources/colors.dart';
import 'package:kid_management/src/ui/common-ui/back-button.dart';
import 'package:kid_management/src/ui/report/app_history_item.dart';
import 'package:kid_management/src/ui/report/report_filter.dart';
import 'package:kid_management/src/ui/report/surf_history_item.dart';
import 'package:pie_chart/pie_chart.dart';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  var _apps = FakeData.getListAllApplication();
  Color _buttonColor = Color(0xffF65656);
  Map<String, double> _chartData = {'USING APP': 80, 'BROWSING WEB': 20};

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'activity report'.toUpperCase(),
          style: TextStyle(
              color: Colors.black, fontSize: 22.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          // The report filter button
          IconButton(
              icon: Icon(
                Icons.filter_alt_sharp,
                color: AppColor.mainColor,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReportFilterScreen(),
                    ));
              })
        ],
      ),
      body: Container(
        height: size.height,
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // THE CHART TO PRESENT TIME TO USE APP AND SURF WEB OF KID
              Container(
                margin: EdgeInsets.only(top: 20.0, bottom: 50.0),
                child: PieChart(
                  dataMap: _chartData,
                  chartRadius: size.width / 2,
                  chartType: ChartType.disc,
                  chartLegendSpacing: 20.0,
                  legendOptions: LegendOptions(
                    showLegends: true,
                    showLegendsInRow: false,
                    legendPosition: LegendPosition.right,
                  ),
                  chartValuesOptions: ChartValuesOptions(
                    showChartValues: true,
                    chartValueBackgroundColor: Colors.transparent,
                    chartValueStyle:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    decimalPlaces: 1,
                    showChartValuesInPercentage: true,
                    showChartValueBackground: false,
                  ),
                ),
              ),
              // TOTAL TIME OF USING SMARTPHONE
              Container(
                width: size.width,
                margin: EdgeInsets.only(bottom: 40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'TOTAL OF TIME USING PHONE',
                      style: TextStyle(color: AppColor.grayDark),
                    ),
                    Text(
                      '48 HOURS 40 MINUTES',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 24.0),
                    ),
                  ],
                ),
              ),
              // APP USAGE REPORT
              // head title
              Text('app usage'.toUpperCase(),
                  style: TextStyle(
                      color: AppColor.grayDark,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0)),
              // sub title
              Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 20.0),
                child: Text('most using'.toUpperCase(),
                    style: TextStyle(fontSize: 16.0)),
              ),
              // top 1 app most use
              Row(
                children: [
                  Container(
                    child: Stack(
                      children: [
                        Positioned(
                          child: SvgPicture.asset(
                            'assets/images/report/crown.svg',
                            width: 20.0,
                            color: Colors.yellow[800],
                          ),
                          top: -5,
                          left: 0,
                          right: 0,
                        ),
                        Text('1',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 40.0))
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Image.memory(
                    _apps[0].icon,
                    height: 30.0,
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Expanded(
                      child: SingleChildScrollView(
                    child: Text(_apps[0].name),
                    scrollDirection: Axis.horizontal,
                  )),
                  Text(
                    'TOTAL IN USE',
                    style: TextStyle(fontSize: 10.0),
                  ),
                  Text(' | ', style: TextStyle(fontSize: 10.0)),
                  Text(
                    '21 H : 20M',
                    style: TextStyle(
                        color: AppColor.mainColor,
                        fontSize: 10.0,
                        fontWeight: FontWeight.bold),
                  ),
                  // RichText(
                  //     text: TextSpan(children: [
                  //   TextSpan(text: '123'),
                  //   TextSpan(text: '123'),
                  // ]))
                ],
              ),
              // top 2 app most use
              Row(
                children: [
                  Container(
                    child: Stack(
                      children: [
                        Positioned(
                          child: SvgPicture.asset(
                            'assets/images/report/crown.svg',
                            width: 20.0,
                            color: AppColor.grayDark,
                          ),
                          top: -5,
                          left: 0,
                          right: 0,
                        ),
                        Text('2',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 40.0))
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Image.memory(
                    _apps[1].icon,
                    height: 30.0,
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Expanded(
                      child: SingleChildScrollView(
                    child: Text(_apps[1].name),
                    scrollDirection: Axis.horizontal,
                  )),
                  Text('TOTAL IN USE', style: TextStyle(fontSize: 10.0)),
                  Text(' | ', style: TextStyle(fontSize: 10.0)),
                  Text(
                    '21 H : 20M',
                    style: TextStyle(
                        color: AppColor.mainColor,
                        fontSize: 10.0,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              // app using history
              // sub title
              Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 20.0),
                child: Text('history'.toUpperCase(),
                    style: TextStyle(fontSize: 16.0)),
              ),
              // app history item
              AppHistoryItem(
                app: _apps[3],
                time: '08:00 AM',
                date: '28/10/2020',
              ),
              AppHistoryItem(
                app: _apps[4],
                time: '11:00 AM',
                date: '27/10/2020',
              ),
              AppHistoryItem(
                app: _apps[6],
                time: '06:12 PM',
                date: '28/10/2020',
              ),
              AppHistoryItem(
                app: _apps[7],
                time: '09:15 PM',
                date: '28/10/2020',
              ),

              SizedBox(
                height: 40.0,
              ),

              // WEB SURFING REPORT
              // head title
              Text('WEB SURFING'.toUpperCase(),
                  style: TextStyle(
                      color: AppColor.grayDark,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0)),
              // sub title
              Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 20.0),
                child: Text('MOST BROWSING'.toUpperCase(),
                    style: TextStyle(fontSize: 16.0)),
              ),
              // top 1 website most browsing
              Row(
                children: [
                  Container(
                    child: Stack(
                      children: [
                        Positioned(
                          child: SvgPicture.asset(
                            'assets/images/report/crown.svg',
                            width: 20.0,
                            color: Colors.yellow[800],
                          ),
                          top: -5,
                          left: 0,
                          right: 0,
                        ),
                        Text('1',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 40.0))
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  SvgPicture.asset(
                    'assets/images/report/chrome.svg',
                    width: 30.0,
                    color: AppColor.mainColor,
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Expanded(
                      child: SingleChildScrollView(
                    child: Text('facebook.com'),
                    scrollDirection: Axis.horizontal,
                  )),
                  Text(
                    'TOTAL IN SURF',
                    style: TextStyle(fontSize: 10.0),
                  ),
                  Text(' | ', style: TextStyle(fontSize: 10.0)),
                  Text(
                    '4H : 10M',
                    style: TextStyle(
                        color: AppColor.mainColor,
                        fontSize: 10.0,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              // top 2 website most browsing
              Row(
                children: [
                  Container(
                    child: Stack(
                      children: [
                        Positioned(
                          child: SvgPicture.asset(
                            'assets/images/report/crown.svg',
                            width: 20.0,
                            color: AppColor.grayDark,
                          ),
                          top: -5,
                          left: 0,
                          right: 0,
                        ),
                        Text('2',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 40.0))
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  SvgPicture.asset(
                    'assets/images/report/chrome.svg',
                    width: 30.0,
                    color: AppColor.mainColor,
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Expanded(
                      child: SingleChildScrollView(
                    child: Text('youtube.com'),
                    scrollDirection: Axis.horizontal,
                  )),
                  Text('TOTAL IN SURF', style: TextStyle(fontSize: 10.0)),
                  Text(' | ', style: TextStyle(fontSize: 10.0)),
                  Text(
                    '2H : 12M',
                    style: TextStyle(
                        color: AppColor.mainColor,
                        fontSize: 10.0,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              // app using history
              // sub title
              Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 20.0),
                child: Text('history'.toUpperCase(),
                    style: TextStyle(fontSize: 16.0)),
              ),
              // app history item
              SurfHistoryItem(
                url:
                    'https://medium.com/flutter/beautiful-animated-charts-for-flutter-164940780b8c',
                time: '08:00 AM',
                date: '28/10/2020',
              ),
              SurfHistoryItem(
                url: 'https://www.youtube.com/watch?v=dShq3wqgzII',
                time: '11:00 AM',
                date: '27/10/2020',
              ),
              SurfHistoryItem(
                url:
                    'https://www.flaticon.com/free-icon/chrome_2374373?term=chrome&page=1&position=4',
                time: '06:12 PM',
                date: '28/10/2020',
              ),
              SurfHistoryItem(
                url:
                    'https://translate.google.com/#view=home&op=translate&sl=vi&tl=en&text=v%C6%B0%C6%A1ng%20mi%E1%BB%87n',
                time: '09:15 PM',
                date: '28/10/2020',
              ),

              // button to clear report info
              Container(
                margin: EdgeInsets.only(top: 40.0, bottom: 10.0),
                child: FlatButton(
                  onPressed: () {},
                  child: Center(
                    child: Text(
                      'clear & reset report'.toUpperCase(),
                      style: TextStyle(color: _buttonColor),
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side: BorderSide(width: 1.0, color: _buttonColor)),
                  height: 50.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

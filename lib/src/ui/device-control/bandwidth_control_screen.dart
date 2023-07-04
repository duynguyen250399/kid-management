import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kid_management/src/resources/colors.dart';

class BandwidthControlScreen extends StatefulWidget {
  @override
  _BandwidthControlScreenState createState() => _BandwidthControlScreenState();
}

class _BandwidthControlScreenState extends State<BandwidthControlScreen> {
  double _currentBandwidthValue = 50;

  Widget _buildBandwidthStatus(double status) {
    String text;
    Color color;

    if (status <= 0) {
      text = 'LOW';
      color = Color(0xff888686);
    } else if (status <= 50) {
      text = 'MEDIUM';
      color = Color(0xff463AB0);
    } else {
      text = 'HIGH';
      color = Color(0xffF65656);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 30.0, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        width: size.width,
        height: size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: size.width * 0.6,
              child: Text(
                'CONTROL INTERNET SPEED OF YOUR KID\'S DEVICE',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0),
              ),
            ),
            SvgPicture.asset(
              'assets/images/device-control/bandwidth.svg',
              width: 250.0,
            ),
            Text('INTERNET SPEED'),
            SizedBox(height: 10.0,),
            BandwidthSlider(
              value: _currentBandwidthValue,
              onChanged: (value) {
                setState(() {
                  _currentBandwidthValue = value;
                });
              },
            ),
            _buildBandwidthStatus(_currentBandwidthValue)
          ],
        ));
  }
}

class BandwidthSlider extends StatefulWidget {
  double value;
  Function onChanged;

  BandwidthSlider({this.value, this.onChanged});

  @override
  _BandwidthSliderState createState() => _BandwidthSliderState();
}

class _BandwidthSliderState extends State<BandwidthSlider> {
  @override
  Widget build(BuildContext context) {
    return SliderTheme(
        data: SliderThemeData(
            // activeTickMarkColor: AppColor.mainColor,
            thumbColor: AppColor.mainColor,
            activeTrackColor: AppColor.mainColor,
            inactiveTrackColor: AppColor.grayLight,
            trackShape: RoundedRectSliderTrackShape(),
            trackHeight: 20.0,
            thumbShape:
                RoundSliderThumbShape(enabledThumbRadius: 20.0, elevation: 5.0),
            inactiveTickMarkColor: AppColor.grayLight.withOpacity(0),
            activeTickMarkColor: AppColor.grayLight.withOpacity(0)),
        child: Slider(
          value: widget.value,
          min: 0,
          max: 100,
          divisions: 2,
          onChanged: widget.onChanged,
        ));
  }
}

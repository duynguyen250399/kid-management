import 'package:flutter/material.dart';
import 'package:kid_management/src/resources/colors.dart';

class BrightnessSlider extends StatefulWidget {
  double value;
  Function onChanged;

  BrightnessSlider({this.value, this.onChanged});

  @override
  _BrightnessSliderState createState() => _BrightnessSliderState();
}

class _BrightnessSliderState extends State<BrightnessSlider> {
  @override
  Widget build(BuildContext context) {
    return  SliderTheme(
      data: SliderThemeData(
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.0),
        inactiveTrackColor: AppColor.grayLight,
        trackShape: RectangularSliderTrackShape()
      ),
      child: Slider(
        value: widget.value,
        min: 0,
        max: 100,
        divisions: 50,
        onChanged: widget.onChanged,
        activeColor: AppColor.mainColor,
      ),
    );
  }
}
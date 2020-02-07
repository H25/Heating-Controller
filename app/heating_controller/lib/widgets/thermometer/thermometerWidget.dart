import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:heating_controller/utility/customTextStyle.dart';
import 'package:heating_controller/widgets/thermometer/thermometerController.dart';

class ThermometerWidget extends StatefulWidget {

  final String mTitle;

  ThermometerWidget({Key key, this.mTitle}): super(key: key);

  @override
  State<StatefulWidget> createState() => ThermometerState();

}

class ThermometerState extends State<ThermometerWidget> {

  ThermometerController mFlareController;
  int mTemperature;

  @override
  void initState() {
    super.initState();
    mFlareController = ThermometerController();
    mTemperature = 0;
  }

  void resetTemperature() {
    if (mounted) {
      setState(() {
        mFlareController.resetTemperature();
        mTemperature = 0;
      });
    }
  }

  /// normal temperature 0-100°C
  void updateTemperature(int temperature) {
    if (mounted) {
      setState(() {
        mFlareController.updateTemperature(temperature);
        mTemperature = temperature;
      });
    }
  }

  /// Pipe temperature goes from 0-200°C
  void updateTemperaturePipe(int temperature) {
    if (mounted) {
      setState(() {
        mFlareController.updateTemperature((temperature*0.5).toInt());
        mTemperature = temperature;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          AspectRatio(
            child: FlareActor(
              "assets/Thermometer.flr",
              controller: mFlareController,
              animation: "fill animation",
              artboard: "Artboard",
              sizeFromArtboard: false,
            ),
            aspectRatio: 50/50
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(widget.mTitle, style: CustomTextStyle.tempDisplay(context)),
                Text(mTemperature.toString() + "°C", style: CustomTextStyle.tempDisplay(context))
              ],
            ),
          )
        ],
      ),
    );
  }

}
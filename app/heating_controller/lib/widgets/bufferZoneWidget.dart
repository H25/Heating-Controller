import 'package:flutter/cupertino.dart';
import 'package:heating_controller/utility/customTextStyle.dart';

class BufferZoneWidget extends StatefulWidget {

  final String mTitle;

  BufferZoneWidget({Key key, this.mTitle}) : super(key: key);

  @override
  State<StatefulWidget> createState() => BufferZoneState();
}

class BufferZoneState extends State<BufferZoneWidget> {

  int mTemperature;

  @override
  void initState() {
    super.initState();
    mTemperature = 0;
  }

  void updateTemperature(int temperature) {
    if (mounted) {
      setState(() {
        mTemperature = temperature;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(left: 24, right: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(widget.mTitle + ": ", style: CustomTextStyle.bufferZoneDisplay(context)),
              Text(mTemperature.toString() + "°C", style: CustomTextStyle.bufferZoneDisplay(context))
            ],
          )
      )
    );
  }

}
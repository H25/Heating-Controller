import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:heating_controller/localization/AppLocalization.dart';
import 'package:heating_controller/widgets/bufferZoneWidget.dart';
import 'package:heating_controller/widgets/thermometer/thermometerWidget.dart';

class BufferTankCard extends StatefulWidget {

  final String mTitleSupply;
  final String mTitleBoiler;

  BufferTankCard({Key key, this.mTitleSupply, this.mTitleBoiler}): super(key: key);

  @override
  State<StatefulWidget> createState() => BufferTankState();

}

class BufferTankState extends State<BufferTankCard> {

  GlobalKey<ThermometerState> mKeyThermometerSupply = GlobalKey<ThermometerState>();
  GlobalKey<ThermometerState> mKeyThermometerBoiler = GlobalKey<ThermometerState>();
  GlobalKey<BufferZoneState> mKeyP1 = GlobalKey<BufferZoneState>();
  GlobalKey<BufferZoneState> mKeyP2 = GlobalKey<BufferZoneState>();
  GlobalKey<BufferZoneState> mKeyP3 = GlobalKey<BufferZoneState>();
  GlobalKey<BufferZoneState> mKeyP4 = GlobalKey<BufferZoneState>();

  @override
  void initState() {
    super.initState();
  }

  void updateTemps ({
      int tempP1,
      int tempP2,
      int tempP3,
      int tempP4,
      int tempSupply,
      int tempBoiler
    }) {
    mKeyP1.currentState.updateTemperature(tempP1);
    mKeyP2.currentState.updateTemperature(tempP2);
    mKeyP3.currentState.updateTemperature(tempP3);
    mKeyP4.currentState.updateTemperature(tempP4);
    mKeyThermometerSupply.currentState.updateTemperature(tempSupply);
    mKeyThermometerBoiler.currentState.updateTemperature(tempBoiler);
  }

  @override
  Widget build(BuildContext context) {

    List<BufferZoneWidget> mBufferZoneWidgets = [
      BufferZoneWidget(key: mKeyP1, mTitle: AppLocalizations.of(context).p1),
      BufferZoneWidget(key: mKeyP2, mTitle: AppLocalizations.of(context).p2),
      BufferZoneWidget(key: mKeyP3, mTitle: AppLocalizations.of(context).p3),
      BufferZoneWidget(key: mKeyP4, mTitle: AppLocalizations.of(context).p4),
    ];

    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.storage),
              title: Text(AppLocalizations.of(context).bufferTank)
            ),
            buildBufferZoneWidgets(context, mBufferZoneWidgets),
            ThermometerWidget(key: mKeyThermometerSupply, mTitle: widget.mTitleSupply),
            ThermometerWidget(key: mKeyThermometerBoiler, mTitle: widget.mTitleBoiler)
          ],
        ),
      ),
    );
  }

}

// build layout depending on screen orientation
Widget buildBufferZoneWidgets(BuildContext context, List<BufferZoneWidget> widgets) {
  if (MediaQuery.of(context).orientation == Orientation.landscape) {
    return buildBufferZoneWidgetLandscape(widgets);
  } else {
    return buildBufferZoneWidgetPortrait(widgets);
  }
}

Widget buildBufferZoneWidgetPortrait(List<BufferZoneWidget> widgets) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          widgets[3],
          widgets[2]
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          widgets[1],
          widgets[0]
        ],
      )
    ]
  );
}

Widget buildBufferZoneWidgetLandscape(List<BufferZoneWidget> widgets) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      widgets[3],
      widgets[2],
      widgets[1],
      widgets[0]
    ],
  );
}
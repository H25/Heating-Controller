import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:heating_controller/localization/AppLocalization.dart';
import 'package:heating_controller/main.dart';
import 'package:heating_controller/utility/constants.dart';
import 'package:heating_controller/utility/networkManager.dart';
import 'package:heating_controller/widgets/thermometer/thermometerWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FurnaceCard extends StatefulWidget {

  final GlobalKey<MyHomePageState> mHomePageKey;

  FurnaceCard({Key key, this.mHomePageKey}): super(key: key);

  @override
  State<StatefulWidget> createState() => FurnaceState();

}

class FurnaceState extends State<FurnaceCard> {

  String mHatchText = "";
  GlobalKey<ThermometerState> mKeyThermometerWidget = GlobalKey<ThermometerState>();

  @override
  void initState() {
    super.initState();
  }

  void updateTemperature(int temperature) {
    mKeyThermometerWidget.currentState.updateTemperaturePipe(temperature);
  }

  void resetTemperature() {
    mKeyThermometerWidget.currentState.resetTemperature();
  }

  void setClosed() {
    if (mounted) {
      setState(() {
        AppLocalizations appLocalizations = AppLocalizations.of(context);
        mHatchText = appLocalizations.closed;
      });
    }
  }

  void setOpen() {
    if (mounted) {
      setState(() {
        AppLocalizations appLocalizations = AppLocalizations.of(context);
        mHatchText = appLocalizations.open;
      });
    }
  }

  Future<void> showAlertDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: true,   // user can tap outside of alert to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).openHatchAlertTitle),
          content: Text(AppLocalizations.of(context).openHatchAlertText),
          actions: <Widget>[
            FlatButton(
              child: Text(AppLocalizations.of(context).cancel.toUpperCase()),
              textColor: Theme.of(context).primaryColor,
              onPressed: (){
                Navigator.of(context).pop(); // dismiss dialog
              },
            ),
            FlatButton(
              child: Text(AppLocalizations.of(context).yes.toUpperCase()),
              textColor: Theme.of(context).primaryColor,
              onPressed: (){
                Navigator.of(context).pop(); // dismiss dialog
                _handleHatchButtonTapped();
              },
            )
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context);
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.whatshot),
            title: Text(appLocalizations.furnace)
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(appLocalizations.hatch + ": "),
                Text(mHatchText, style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold)),
                Spacer(),
                _buildButtonWidget(),
              ],
            )
          ),
          ThermometerWidget(key: mKeyThermometerWidget, mTitle:appLocalizations.pipe),
        ],
      ),
    );
  }

  MaterialButton _buildButtonWidget() {
    return MaterialButton(
      child: Text(AppLocalizations.of(context).openHatch, style: TextStyle(fontWeight: FontWeight.bold)),
      color: Theme.of(context).primaryColor,
      textColor: Colors.white,
      disabledColor: Colors.black12,
      onPressed: (mHatchText == AppLocalizations.of(context).open) ? null : (){
        // if hatch state is closed show an alert for opening the hatch
        showAlertDialog();
      },
    );
  }

  void _handleHatchButtonTapped() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(PREF_DEMO_MODE)) {
      // demo mode
      if (prefs.getBool(PREF_DEMO_MODE) == true) {
        setOpen();
        return;
      }
    }
    // prod mode
    await NetworkManager.openHatch().then((value) {
      // when request for opening finishes request new values
      widget.mHomePageKey.currentState.mRefreshIndicatorKey.currentState.show();
    }).catchError((error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: Text(AppLocalizations.of(context).errorAlertTitle),
            content: Text(error),
            actions: <Widget>[
              new FlatButton(
                child: Text(AppLocalizations.of(context).ok, style: TextStyle(color: Theme.of(context).primaryColor)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    });
    return null;
  }
}

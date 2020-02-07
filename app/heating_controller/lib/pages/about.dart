import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heating_controller/localization/AppLocalization.dart';
import 'package:package_info/package_info.dart';

class About extends StatefulWidget {
  
  About({Key key}): super(key: key);

  @override
  State<StatefulWidget> createState() => AboutState();
}

class AboutState extends State<About> {

  String _mVersion = "";

  void getVersion(BuildContext context) {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        _mVersion = packageInfo.version;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    getVersion(context);
    final String title = AppLocalizations.of(context).about;
    return new Scaffold(
        appBar: AppBar(title: Text(title)),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(AppLocalizations.of(context).aboutDescription1),
              Padding(
                padding: EdgeInsets.only(left: 16.0, top: 4.0),
                child: Text(AppLocalizations.of(context).aboutDescription2)
              ),
              Padding(
                padding: EdgeInsets.only(left: 32.0),
                child: Text(AppLocalizations.of(context).aboutDescription3)
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.0, bottom: 4.0),
                child: Text(AppLocalizations.of(context).aboutDescription4)
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 32.0),
                child: Text(AppLocalizations.of(context).aboutDescription5)
              ),
              Text(AppLocalizations.of(context).version + _mVersion)
            ],
          ),
        )
    );
  }

}
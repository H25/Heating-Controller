import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:heating_controller/pages/about.dart';
import 'package:heating_controller/pages/settings.dart';
import 'package:heating_controller/utility/constants.dart';
import 'package:heating_controller/utility/networkManager.dart';
import 'package:heating_controller/widgets/bufferTankCard.dart';
import 'package:heating_controller/widgets/furnaceCard.dart';
import 'package:heating_controller/localization/AppLocalization.dart';
import 'package:heating_controller/utility/testDataMaker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:heating_controller/pages/history.dart';

void main() => runApp(MyApp());

Measurement mGlobalMeasurement;
final GlobalKey _mKeyHomePage = GlobalKey<MyHomePageState>();

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        const AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'), // English
        const Locale('de'), // German
      ],
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: Colors.amber[900],
        accentColor: Colors.amberAccent,
        primaryColorLight: Colors.amberAccent,
        primaryColorDark: Colors.deepOrange
      ),
      title: "Heating Controller",
      home: MyHomePage(key: _mKeyHomePage)
    );
  }
}

class MyHomePage extends StatefulWidget {

  MyHomePage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyHomePageState();
  }
}

class MyHomePageState extends State<MyHomePage> {

  GlobalKey mKeyFurnaceCard = GlobalKey();
  GlobalKey mKeyBufferTankCard = GlobalKey();
  final GlobalKey<RefreshIndicatorState> mRefreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  static bool _mStarted = false;

  @override
  void initState() {
    super.initState();
    // load data automatically on start
    WidgetsBinding.instance.addPostFrameCallback((_) => mRefreshIndicatorKey.currentState.show());
  }

  @override
  Widget build(BuildContext context) {
    final appTitle = AppLocalizations.of(context).appName;
    return Scaffold(
        appBar: AppBar(title: Text(appTitle)),
        body: RefreshIndicator(
            key: mRefreshIndicatorKey,
            color: Theme.of(context).primaryColor,
            backgroundColor: Colors.white,
            onRefresh: () {
              if (_mStarted) {
                return _getUpdatedDatabaseValue();
              } else {
                return _getLatestDataOfDatabase();
              }
            },
            child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      FurnaceCard(key: mKeyFurnaceCard, mHomePageKey: _mKeyHomePage),
                      BufferTankCard(
                        key: mKeyBufferTankCard,
                        mTitleSupply: AppLocalizations.of(context).supply,
                        mTitleBoiler: AppLocalizations.of(context).boiler)
                    ],
                  ),
                )
            )
        ),
        drawer: MainDrawer(appTitle: appTitle)
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// called when the app starts
  Future<Null> _getLatestDataOfDatabase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(PREF_DEMO_MODE)) {
      // demo mode
      if (prefs.getBool(PREF_DEMO_MODE) == true) {
        await TestDataMaker.getRandomDataDelayed(2).then((value) {
          _processData(value);
        });
        return null;
      }
    }
    // prod mode
    await NetworkManager.fetchCurrentValues().then((value) {
      _processData(value);
    }).catchError((error) {
      _showBasicOkDialog(AppLocalizations.of(context).errorAlertTitle, error);
    });
    return null;
  }

  /// called when user pulls down to refresh
  /// in order to force the esp to write a new value to the database
  /// or the user wants to open the hatch
  Future<Null> _getUpdatedDatabaseValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(PREF_DEMO_MODE)) {
      // demo mode
      if (prefs.getBool(PREF_DEMO_MODE) == true) {
        await TestDataMaker.getRandomDataDelayed(2).then((value) {
          _processData(value);
        });
        return null;
      }
    }
    // prod mode
    await NetworkManager.update().then((value) async {
      int retry = 0;
      bool shouldBreak = false;
      String errorMessage;
      while (true) {
        // give the esp some time to write new values into the database
        await Future.delayed(Duration(seconds: DELAY_BETWEEN_RETRY));
        await NetworkManager.fetchCurrentValues().then((value) {
          if (value.time.isAfter(mGlobalMeasurement.time)) {
            _processData(value);
            shouldBreak = true;
          }
        }).catchError((error) {
          errorMessage = error;
          retry = 2;
        });
        if (shouldBreak) {
          // got new value
          break;
        } else if (retry == 2) {
          // tried it already 3 times or an error occurred
          if (errorMessage == null || errorMessage.isEmpty) {
            errorMessage = AppLocalizations.of(context).errorMessageRetryExceeded;
          }
          _showBasicOkDialog(AppLocalizations.of(context).errorAlertTitle, errorMessage);
          break;
        }
        retry++;
      }
    }).catchError((error) {
      _showBasicOkDialog(AppLocalizations.of(context).errorAlertTitle, error);
    });
    return null;
  }

  /// shows a basic dialog with [title], [message] and an ok button
  void _showBasicOkDialog(String title, String message) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text(title),
          content: Text(message),
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
  }

  /// update the different widgets
  void _processData(Measurement value) {
    mGlobalMeasurement = value;
    // save data for history page
    mGlobalMeasurement = value;
    // update views
    FurnaceState furnaceState = mKeyFurnaceCard.currentState;
    furnaceState.updateTemperature(value.tempPipe);
    value.hatchState == true ? furnaceState.setOpen() : furnaceState.setClosed();
    BufferTankState bufferTankState = mKeyBufferTankCard.currentState;
    bufferTankState.updateTemps(
      tempBoiler: value.tempBoiler,
      tempSupply: value.tempSupply,
      tempP4: value.tempP4,
      tempP3: value.tempP3,
      tempP2: value.tempP2,
      tempP1: value.tempP1,
    );
    _mStarted = true;
  }
}

class MainDrawer extends StatelessWidget {
  final String appTitle;

  MainDrawer({Key key, this.appTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Center(child:
                Column(
                  children: <Widget>[
                    Image(
                      height: 96,
                      width: 96,
                      image: AssetImage("heating_controller_icon.png"),
                    ),
                    Text(appTitle, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20))
                  ],
                )
              ),
            decoration: BoxDecoration(color: Theme.of(context).primaryColor)
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text(AppLocalizations.of(context).home),
            onTap: () {
              // close drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text(AppLocalizations.of(context).history),
            onTap: () {
              // close drawer
              Navigator.of(context).pop();
              // navigate to history page
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => History(mInitialValues: mGlobalMeasurement)));
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(AppLocalizations.of(context).settings),
            onTap: () {
              // close drawer
              Navigator.of(context).pop();
              // navigate to settings page
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => Settings()));
            },
          ),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text(AppLocalizations.of(context).about),
            onTap: () {
              // close drawer
              Navigator.of(context).pop();
              // navigate to about page
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => About()));
            },
          ),
        ],
      ),
    );
  }
}

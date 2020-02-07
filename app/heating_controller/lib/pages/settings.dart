import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heating_controller/localization/AppLocalization.dart';
import 'package:heating_controller/utility/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ConnectionType { vpn, ip }

class Settings extends StatefulWidget {

  Settings({Key key}): super(key: key);

  @override
  State<StatefulWidget> createState() => SettingsState();

}

class SettingsState extends State<Settings> {

  ConnectionType _type = ConnectionType.ip;
  bool _demoMode = false;
  String _hostIP = DEFAULT_HOST_IP;
  String _portIP = DEFAULT_PORT_IP;
  String _hostVPN = DEFAULT_HOST_VPN;
  String _portVPN = DEFAULT_PORT_VPN;
  TextEditingController _hostControllerIP = TextEditingController(text: DEFAULT_HOST_IP);
  TextEditingController _portControllerIP = TextEditingController(text: DEFAULT_PORT_IP);
  TextEditingController _hostControllerVPN = TextEditingController(text: DEFAULT_HOST_VPN);
  TextEditingController _portControllerVPN = TextEditingController(text: DEFAULT_PORT_VPN);

  @override
  void initState() {
    super.initState();
    _getPrefValues();
  }

  @override
  void dispose() {
    _hostControllerIP.dispose();
    _portControllerIP.dispose();
    _hostControllerVPN.dispose();
    _portControllerVPN.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String title = AppLocalizations.of(context).settings;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              Card(
                child: SwitchListTile(
                  title: Text(AppLocalizations.of(context).enableDemoMode),
                  subtitle: Text(AppLocalizations.of(context).enableDemoModeDescription),
                  value: _demoMode,
                  onChanged: (bool) {
                    _saveDemoValue(bool);
                  },
                )
              ),
              Card(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(AppLocalizations.of(context).server),
                      subtitle: Text(AppLocalizations.of(context).serverDescription),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Radio(
                          value: ConnectionType.ip,
                          groupValue: _type,
                          onChanged: (ConnectionType type) {
                            _saveConnectionType(type);
                          },
                        ),
                        Expanded(
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 16),
                                          child: TextFormField(
                                              controller: _hostControllerIP,
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(10)
                                                  ),
                                                  labelText: AppLocalizations.of(context).hostIP
                                              ),
                                              onChanged: (value) {
                                                _saveHostValueIP(value);
                                              }
                                          ),
                                        )
                                    )
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                                          child: TextFormField(
                                              controller: _portControllerIP,
                                              keyboardType: TextInputType.number,
                                              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(10)
                                                  ),
                                                  labelText: AppLocalizations.of(context).portIP
                                              ),
                                              onChanged: (value){
                                                _savePortValueIP(value);
                                              }
                                          ),
                                        )
                                    )
                                  ],
                                ),
                              ],
                            )
                        )
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Radio(
                          value: ConnectionType.vpn,
                          groupValue: _type,
                          onChanged: (ConnectionType type) {
                            _saveConnectionType(type);
                          },
                        ),
                        Expanded(
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                                          child: TextFormField(
                                              controller: _hostControllerVPN,
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(10)
                                                  ),
                                                  labelText: AppLocalizations.of(context).hostVPN
                                              ),
                                              onChanged: (value) {
                                                _saveHostValueVPN(value);
                                              }
                                          ),
                                        )
                                    )
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                                          child: TextFormField(
                                              controller: _portControllerVPN,
                                              keyboardType: TextInputType.number,
                                              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(10)
                                                  ),
                                                  labelText: AppLocalizations.of(context).portVPN
                                              ),
                                              onChanged: (value){
                                                _savePortValueVPN(value);
                                              }
                                          ),
                                        )
                                    )
                                  ],
                                ),
                              ],
                            )
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          )
        )
      )
    );
  }

  void _getPrefValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _demoMode = prefs.getBool(PREF_DEMO_MODE) ?? false;
      _hostIP = prefs.getString(PREF_HOST_IP) ?? DEFAULT_HOST_IP;
      _portIP = prefs.getString(PREF_PORT_IP) ?? DEFAULT_PORT_IP;
      _hostVPN = prefs.getString(PREF_HOST_VPN) ?? DEFAULT_HOST_VPN;
      _portVPN = prefs.getString(PREF_PORT_VPN) ?? DEFAULT_PORT_VPN;
      _type = prefs.getString(PREF_CONNECTION_TYPE) == ConnectionType.vpn.toString() ? ConnectionType.vpn : ConnectionType.ip;
      _hostControllerIP.text = _hostIP;
      _portControllerIP.text = _portIP;
      _hostControllerVPN.text = _hostVPN;
      _portControllerVPN.text = _portVPN;
    });
  }

  void _saveDemoValue(bool bool) async {
    setState(() {
      _demoMode = bool;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(PREF_DEMO_MODE, bool);
  }

  void _saveHostValueIP(String newHost) async {
    setState(() {
      _hostIP = newHost;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(PREF_HOST_IP, newHost);
  }

  void _savePortValueIP(String newPort) async {
    setState(() {
      _portIP = newPort;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(PREF_PORT_IP, newPort);
  }

  void _saveHostValueVPN(String newHost) async {
    setState(() {
      _hostVPN = newHost;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(PREF_HOST_VPN, newHost);
  }

  void _savePortValueVPN(String newPort) async {
    setState(() {
      _portVPN = newPort;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(PREF_PORT_VPN, newPort);
  }

  void _saveConnectionType(ConnectionType type) async {
    setState(() {
      _type = type;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(PREF_CONNECTION_TYPE, type.toString());
  }

}
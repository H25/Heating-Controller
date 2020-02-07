import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'about': "About",
      'about_description1': 'This app was developed with the Framework Flutter as a result of project at our university. The aim of this app is to visualize different values of a heating system:',
      'about_description2': '- Temperature',
      'about_description3': '- Pipe\n- Boiler\n- Supply\n- Buffer Tank',
      'about_description4': '- State of the hatch',
      'about_description5': 'Additionaly, the furnace\'s hatch can be opened.',
      'app_name': 'Heating Controller',
      'boiler': 'Boiler',
      'buffer_tank': "Buffer Tank",
      'cancel': 'Cancel',
      'closed': 'closed',
      'date': 'Date:',
      'download_data': 'Downloading Data ...',
      'enable_demo_mode': 'Enable Demo Mode',
      'enable_demo_mode_description': 'Enabling the Demo Mode will show only fake data. No requests will be made to the backend.',
      'error_alert_title': 'Error',
      'error_message_retry_exceeded': 'The ESP hasn\'t written a new value into the database.',
      'furnace': "Furnace",
      'hatch': 'Hatch',
      'history': 'History',
      'home': "Home",
      'host_ip': 'Host IP',
      'host_vpn': 'Host VPN',
      'no': 'No',
      'ok': 'OK',
      'open': 'open',
      'open_hatch': 'Open Hatch',
      'open_hatch_alert_title': 'Open',
      'open_hatch_alert_text': 'Are you sure to open the hatch?',
      'p1': 'P1',
      'p2': 'P2',
      'p3': 'P3',
      'p4': 'P4',
      'period': 'Period:',
      'pipe': 'Pipe',
      'port_ip': 'Port IP',
      'port_vpn': 'Port VPN',
      'server': 'Server',
      'server_description': 'Select the connection type: vpn or ip. If necessary, change the host or the port.',
      'settings': 'Settings',
      'supply': 'Supply',
      'temperature': "Temperature",
      'update': 'update',
      'version': 'Version: ',
      'yes': 'Yes'
    },
    'de': {
      'about': "About",
      'about_description1': 'Diese App wurde im Rahmen einer Projektarbeit mit dem Framework Flutter programmiert. Aufgabe der App ist es die verschiedenen Werte des Heizsystems anzuzeigen:',
      'about_description2': '- Temperatur',
      'about_description3': '- Rohr\n- Boiler\n- Zulauf\n- Pufferspeicher',
      'about_description4': '- Zustand der Zuluftklappe',
      'about_description5': 'Zusätzlich kann noch die Zuluftklappe des Kachelofens geöffnet werden.',
      'app_name': 'Heating Controller',
      'boiler': 'Boiler',
      'buffer_tank': "Pufferspeicher",
      'cancel': 'Abbrechen',
      'closed': 'geschlossen',
      'enable_demo_mode': 'Demo Mode aktivieren',
      'date': 'Zeitpunkt:',
      'download_data': 'Lade Daten herunter ...',
      'enable_demo_mode_description': 'Im Demo Modus werden Zufallswerte angezeigt. Es besteht keine Verbindung zum Server.',
      'error_alert_title': 'Fehler',
      'error_message_retry_exceeded': 'Der ESP hat bis jetzt keine neuen Werte in die Datenbank geschrieben.',
      'furnace': "Heizofen",
      'hatch': 'Klappe',
      'history': 'Verlauf',
      'home': "Home",
      'host_ip': 'Host IP',
      'host_vpn': 'Host VPN',
      'no': 'Nein',
      'ok': 'OK',
      'open': 'geöffnet',
      'open_hatch': 'Öffnen',
      'open_hatch_alert_title': 'Klappe öffnen',
      'open_hatch_alert_text': 'Bist du dir sicher, dass du die Klappe öffnen willst?',
      'p1': 'P1',
      'p2': 'P2',
      'p3': 'P3',
      'p4': 'P4',
      'period': 'Zeitraum:',
      'pipe': 'Rohr',
      'port_ip': 'Port IP',
      'port_vpn': 'Port VPN',
      'server': 'Server',
      'server_description': 'Wähle hier den Verbindungstyp aus: über VPN oder direkt über die IP-Adresse. Falls nötig ändere den Host oder den Port des jeweiligen Verbindungstyps.',
      'settings': 'Settings',
      'supply': 'Zulauf',
      'temperature': "Temperatur",
      'update': 'Update',
      'version': 'Version: ',
      'yes': 'Ja'
    },
  };

  String get about {
    return _localizedValues[locale.languageCode]['about'];
  }
  String get aboutDescription1 {
    return _localizedValues[locale.languageCode]['about_description1'];
  }
  String get aboutDescription2 {
    return _localizedValues[locale.languageCode]['about_description2'];
  }
  String get aboutDescription3 {
    return _localizedValues[locale.languageCode]['about_description3'];
  }
  String get aboutDescription4 {
    return _localizedValues[locale.languageCode]['about_description4'];
  }
  String get aboutDescription5 {
    return _localizedValues[locale.languageCode]['about_description5'];
  }
  String get appName {
    return _localizedValues[locale.languageCode]['app_name'];
  }
  String get boiler {
    return _localizedValues[locale.languageCode]['boiler'];
  }
  String get bufferTank {
    return _localizedValues[locale.languageCode]['buffer_tank'];
  }
  String get cancel {
    return _localizedValues[locale.languageCode]['cancel'];
  }
  String get closed {
    return _localizedValues[locale.languageCode]['closed'];
  }
  String get date {
    return _localizedValues[locale.languageCode]['date'];
  }
  String get downloadData {
    return _localizedValues[locale.languageCode]['download_data'];
  }
  String get enableDemoMode {
    return _localizedValues[locale.languageCode]['enable_demo_mode'];
  }
  String get enableDemoModeDescription {
    return _localizedValues[locale.languageCode]['enable_demo_mode_description'];
  }
  String get errorAlertTitle {
    return _localizedValues[locale.languageCode]['error_alert_title'];
  }
  String get errorMessageRetryExceeded {
    return _localizedValues[locale.languageCode]['error_message_retry_exceeded'];
  }
  String get furnace {
    return _localizedValues[locale.languageCode]['furnace'];
  }
  String get hatch {
    return _localizedValues[locale.languageCode]['hatch'];
  }
  String get history {
    return _localizedValues[locale.languageCode]['history'];
  }
  String get home {
    return _localizedValues[locale.languageCode]['home'];
  }
  String get hostIP {
    return _localizedValues[locale.languageCode]['host_ip'];
  }
  String get hostVPN {
    return _localizedValues[locale.languageCode]['host_vpn'];
  }
  String get no {
    return _localizedValues[locale.languageCode]['no'];
  }
  String get ok {
    return _localizedValues[locale.languageCode]['ok'];
  }
  String get open {
    return _localizedValues[locale.languageCode]['open'];
  }
  String get openHatch {
    return _localizedValues[locale.languageCode]['open_hatch'];
  }
  String get openHatchAlertTitle {
    return _localizedValues[locale.languageCode]['open_hatch_alert_title'];
  }
  String get openHatchAlertText {
    return _localizedValues[locale.languageCode]['open_hatch_alert_text'];
  }
  String get p1 {
    return _localizedValues[locale.languageCode]['p1'];
  }
  String get p2 {
    return _localizedValues[locale.languageCode]['p2'];
  }
  String get p3 {
    return _localizedValues[locale.languageCode]['p3'];
  }
  String get p4 {
    return _localizedValues[locale.languageCode]['p4'];
  }
  String get period {
    return _localizedValues[locale.languageCode]['period'];
  }
  String get pipe {
    return _localizedValues[locale.languageCode]['pipe'];
  }
  String get portIP {
    return _localizedValues[locale.languageCode]['port_ip'];
  }
  String get portVPN {
    return _localizedValues[locale.languageCode]['port_vpn'];
  }
  String get server {
    return _localizedValues[locale.languageCode]['server'];
  }
  String get serverDescription {
    return _localizedValues[locale.languageCode]['server_description'];
  }
  String get settings {
    return _localizedValues[locale.languageCode]['settings'];
  }
  String get supply {
    return _localizedValues[locale.languageCode]['supply'];
  }
  String get temperature {
    return _localizedValues[locale.languageCode]['temperature'];
  }
  String get update {
    return _localizedValues[locale.languageCode]['update'];
  }
  String get version {
    return _localizedValues[locale.languageCode]['version'];
  }
  String get yes {
    return _localizedValues[locale.languageCode]['yes'];
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'de'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
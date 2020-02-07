import 'package:charts_flutter/flutter.dart' as charts;

// shared preferences keys
const String PREF_DEMO_MODE = "pref_demo_mode";
const String PREF_HOST_IP = "pref_host_ip";
const String PREF_PORT_IP = "pref_port_ip";
const String PREF_HOST_VPN = "pref_host_vpn";
const String PREF_PORT_VPN = "pref_port_vpn";
const String PREF_CONNECTION_TYPE = "pref_connection_type";

// thermometer widget
const int MAX_TEMP = 100;

// test data map keys
const String KEY_MAP_TEMP_PIPE = 'rohr';
const String KEY_MAP_TEMP_P1 = 'puffer1';
const String KEY_MAP_TEMP_P2 = 'puffer2';
const String KEY_MAP_TEMP_P3 = 'puffer3';
const String KEY_MAP_TEMP_P4 = 'puffer4';
const String KEY_MAP_TEMP_SUPPLY = 'zulauf';
const String KEY_MAP_TEMP_BOILER = 'boiler';
const String KEY_MAP_HATCH_STATE = 'klappe';
const String KEY_MAP_TIME = "datum";

// charts
const int NUMBER_OF_DISPLAYED_VALUES = 7; // pipe, boiler, supply, p1-4
const String KEY_MAP_ID = "id";
const String KEY_MAP_COLOR = "color";

final mappedChartsStyling = [
  {
    KEY_MAP_ID: "Pipe",
    KEY_MAP_COLOR: charts.MaterialPalette.red.shadeDefault,
  },
  {
    KEY_MAP_ID: "P1",
    KEY_MAP_COLOR: charts.MaterialPalette.cyan.shadeDefault,
  },
  {
    KEY_MAP_ID: "P2",
    KEY_MAP_COLOR: charts.MaterialPalette.blue.shadeDefault,
  },
  {
    KEY_MAP_ID: "P3",
    KEY_MAP_COLOR: charts.MaterialPalette.indigo.shadeDefault,
  },
  {
    KEY_MAP_ID: "P4",
    KEY_MAP_COLOR: charts.MaterialPalette.purple.shadeDefault,
  },
  {
    KEY_MAP_ID: "Supply",
    KEY_MAP_COLOR: charts.MaterialPalette.deepOrange.shadeDefault,
  },
  {
    KEY_MAP_ID: "Boiler",
    KEY_MAP_COLOR: charts.MaterialPalette.yellow.shadeDefault,
  },
];

/// backend urls
const String DEFAULT_HOST_IP = "http://192.168.178.111";
const String DEFAULT_PORT_IP = "8080";
const String DEFAULT_HOST_VPN = "https://my-vpn-server.net";
const String DEFAULT_PORT_VPN = "1890";
const String BASE_PATH = "/api/heating_controller/";
const String PATH_CURRENT_VALUES = "currentValues";
const String PATH_OPEN_HATCH = "open_hatch/true";
const String PATH_UPDATE = "update/true";
const String PATH_SERIES = "series";
const int TIMEOUT = 20;
const int DELAY_BETWEEN_RETRY = 5;
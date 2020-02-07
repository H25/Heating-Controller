import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:heating_controller/pages/settings.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';

class NetworkManager {

  static Future<Measurement> fetchCurrentValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String connectionType = prefs.getString(PREF_CONNECTION_TYPE) ?? ConnectionType.ip.toString();
    String host;
    String port;
    if (connectionType == ConnectionType.ip.toString()) {
      host = prefs.getString(PREF_HOST_IP) ?? DEFAULT_HOST_IP;
      port = prefs.getString(PREF_PORT_IP) ?? DEFAULT_PORT_IP;
    } else {
      host = prefs.getString(PREF_HOST_VPN) ?? DEFAULT_HOST_VPN;
      port = prefs.getString(PREF_PORT_VPN) ?? DEFAULT_PORT_VPN;
    }
    String url = Uri.encodeFull(host + ":" + port + BASE_PATH + PATH_CURRENT_VALUES);
    print("Request current values! URL: $url");
    String message;
    try {
      final response = await http.get(url)
          .timeout(Duration(seconds: TIMEOUT));
      if (response.statusCode == 200) {
        /// If server returns an OK response, parse the JSON.
        return Measurement.fromJson(json.decode(response.body));
      } else {
        /// get error message
        message = json.decode(response.body)["message"]
            + " (HTTP Error Code: " + response.statusCode + ")";
        message = message != null ? message : "unknown error";
        print("Error fetching current values: $message");
        return Future.error(message);
      }
    } on TimeoutException catch (error) {
      print("Request timed out after $TIMEOUT seconds.");
      return Future.error("Request timed out nach $TIMEOUT Sekunden .");
    } on SocketException catch (error) {
      print("Server is not reachable. (${error.address})");
      return Future.error("Server ist nicht erreichbar (Socket Exception). (${error.address})");
    } catch (error) {
      print(error.toString());
      message = message == null ? error.toString() : message;
      return Future.error(message);
    }
  }

  static Future<void> openHatch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String connectionType = prefs.getString(PREF_CONNECTION_TYPE) ?? ConnectionType.ip.toString();
    String host;
    String port;
    if (connectionType == ConnectionType.ip.toString()) {
      host = prefs.getString(PREF_HOST_IP) ?? DEFAULT_HOST_IP;
      port = prefs.getString(PREF_PORT_IP) ?? DEFAULT_PORT_IP;
    } else {
      host = prefs.getString(PREF_HOST_VPN) ?? DEFAULT_HOST_VPN;
      port = prefs.getString(PREF_PORT_VPN) ?? DEFAULT_PORT_VPN;
    }
    String message;
    String url = Uri.encodeFull(host + ":" + port + BASE_PATH + PATH_OPEN_HATCH);
    print("Open Hatch! (URL: $url");
    try {
      final response = await http.get(url)
          .timeout(Duration(seconds: TIMEOUT)).catchError((error) {
        message = error.toString();
        if (error is TimeoutException) {
          message = "Request timed out.";
        }
        print("Error trying to open hatch: $message");
        return Future.error(message);
      });
      if (response.statusCode == 200) {
        return;
      } else {
        /// get error message
        message = json.decode(response.body)["message"]
            + " (HTTP Error Code: " + response.statusCode + ")";
        message = message != null ? message : "unknown error";
        print("Error opening hatch: $message");
        return Future.error(message);
      }
    } on TimeoutException catch (error) {
      print("Request timed out after $TIMEOUT seconds.");
      return Future.error("Request timed out nach $TIMEOUT Sekunden .");
    } on SocketException catch (error) {
      print("Server is not reachable. (${error.address})");
      return Future.error("Server ist nicht erreichbar (Socket Exception). (${error.address})");
    } catch (error) {
      print(error.toString());
      message = message == null ? error.toString() : message;
      return Future.error(message);
    }
  }

  static Future<void> update() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String connectionType = prefs.getString(PREF_CONNECTION_TYPE) ?? ConnectionType.ip.toString();
    String host;
    String port;
    if (connectionType == ConnectionType.ip.toString()) {
      host = prefs.getString(PREF_HOST_IP) ?? DEFAULT_HOST_IP;
      port = prefs.getString(PREF_PORT_IP) ?? DEFAULT_PORT_IP;
    } else {
      host = prefs.getString(PREF_HOST_VPN) ?? DEFAULT_HOST_VPN;
      port = prefs.getString(PREF_PORT_VPN) ?? DEFAULT_PORT_VPN;
    }
    String url = Uri.encodeFull(host + ":" + port + BASE_PATH + PATH_UPDATE);
    print("Force ESP to update database! (URL: $url");
    String message;
    try {
      final response = await http.get(url)
          .timeout(Duration(seconds: TIMEOUT)).catchError((error) {
        message = error.toString();
        if (error is TimeoutException) {
          message = "Request timed out.";
        }
        print("Error forcing the ESP to update database: $message");
        return Future.error(message);
      });
      if (response.statusCode == 200) {
        return;
      } else {
        /// get error message
        message = json.decode(response.body)["message"]
            + " (HTTP Error Code: " + response.statusCode + ")";
        message = message != null ? message : "unknown error";
        print("Error updating: $message");
        return Future.error(message);
      }
    } on TimeoutException catch (error) {
      print("Request timed out after $TIMEOUT seconds.");
      return Future.error("Request timed out nach $TIMEOUT Sekunden .");
    } on SocketException catch (error) {
      print("Server is not reachable. (${error.address})");
      return Future.error("Server ist nicht erreichbar (Socket Exception). (${error.address})");
    } catch (error) {
      print(error.toString());
      message = message == null ? error.toString() : message;
      return Future.error(message);
    }
  }

  static Future<MeasurementSeries> fetchSeries(DateTime start, DateTime end) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String connectionType = prefs.getString(PREF_CONNECTION_TYPE) ?? ConnectionType.ip.toString();
    String host;
    String port;
    if (connectionType == ConnectionType.ip.toString()) {
      host = prefs.getString(PREF_HOST_IP) ?? DEFAULT_HOST_IP;
      port = prefs.getString(PREF_PORT_IP) ?? DEFAULT_PORT_IP;
    } else {
      host = prefs.getString(PREF_HOST_VPN) ?? DEFAULT_HOST_VPN;
      port = prefs.getString(PREF_PORT_VPN) ?? DEFAULT_PORT_VPN;
    }
    String url = Uri.encodeFull(
              host
            + ":" + port
            + BASE_PATH
            + PATH_SERIES
            + "/" + start.toIso8601String()
            + "/" + end.toIso8601String());
    print("Request series! (URL: $url");
    String message;
    try {
      final response = await http.get(url)
          .timeout(Duration(seconds: TIMEOUT)).catchError((error) {
        message = error.toString();
        if (error is TimeoutException) {
          message = "Request timed out.";
        }
        print("Error fetching series: $message");
        return Future.error(message);
      });
      if (response.statusCode == 200) {
        /// If server returns an OK response, parse the JSON.
        return MeasurementSeries.fromJson(json.decode(response.body));
      } else {
        /// get error message
        message = json.decode(response.body)["message"]
            + " (HTTP Error Code: " + response.statusCode.toString() + ")";
        message = message != null ? message : "unknown error";
        print("Error fetching series: $message");
        return Future.error(message);
      }
    } on TimeoutException catch (error) {
      print("Request timed out after $TIMEOUT seconds.");
      return Future.error("Request timed out nach $TIMEOUT Sekunden .");
    } on SocketException catch (error) {
      print("Server is not reachable. (${error.address})");
      return Future.error("Server ist nicht erreichbar (Socket Exception). (${error.address})");
    } catch (error) {
      print(error.toString());
      message = message == null ? error.toString() : message;
      return Future.error(message);
    }
  }

}

class Measurement {
  final DateTime time;
  final int tempPipe;
  final int tempP4;
  final int tempP3;
  final int tempP2;
  final int tempP1;
  final int tempSupply;
  final int tempBoiler;
  final bool hatchState;

  Measurement({this.time, this.tempPipe, this.tempP4, this.tempP3, this.tempP2,
    this.tempP1, this.tempSupply, this.tempBoiler, this.hatchState});

  factory Measurement.fromJson(Map<String, dynamic> json) {
    return Measurement(
      time: DateTime.parse(json[KEY_MAP_TIME]).toLocal(),
      tempPipe: json[KEY_MAP_TEMP_PIPE],
      tempP4: json[KEY_MAP_TEMP_P4],
      tempP3: json[KEY_MAP_TEMP_P3],
      tempP2: json[KEY_MAP_TEMP_P2],
      tempP1: json[KEY_MAP_TEMP_P1],
      tempSupply: json[KEY_MAP_TEMP_SUPPLY],
      tempBoiler: json[KEY_MAP_TEMP_BOILER],
      hatchState: json[KEY_MAP_HATCH_STATE] == 1 ? true : false
    );
  }
}

class MeasurementSeries {
  final List<Measurement> measurements;

  MeasurementSeries({this.measurements});

  factory MeasurementSeries.fromJson(List <dynamic> json) {
    List<Measurement> measurements = List();
    for (var jsonObject in json) {
      measurements.add(Measurement.fromJson(jsonObject));
    }
    return MeasurementSeries(measurements: measurements);
  }
}

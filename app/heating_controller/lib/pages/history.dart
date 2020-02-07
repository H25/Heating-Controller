import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:heating_controller/localization/AppLocalization.dart';
import 'package:heating_controller/utility/constants.dart';
import 'package:heating_controller/utility/networkManager.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:heating_controller/utility/testDataMaker.dart';

class History extends StatefulWidget {

  final Measurement mInitialValues;

  History({Key key, this.mInitialValues}): super(key: key);

  @override
  State<StatefulWidget> createState() => HistoryState();
}

class HistoryState extends State<History> {

  DateTime _mDateTime;
  static const double CHART_HEIGHT_PORTRAIT = 350;
  static const double CHART_HEIGHT_LANDSCAPE = 300;
  String _mSelectedPeriod;
  static const List<String> _mPeriodList = ["1h", "2h", "4h", "12h", "1d"];
  List<charts.Series<TimeSeriesHistory, DateTime>> mChartSeriesList;
  ProgressDialog _mProgressDialog;
  List<String> _mChartDisplayNames;

  @override
  void initState() {
    super.initState();
    _mDateTime = DateTime.now();
    _mSelectedPeriod = "1h";
    _initChart();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // update the chart after all widgets are build otherwise AppLocalization
      // crashes since context is not valid
      _setChartDisplayNames();
      if (widget.mInitialValues != null) {
        _updateChartData(
            MeasurementSeries(measurements: [widget.mInitialValues]));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _buildProgressDialog();
    final String title = AppLocalizations.of(context).history;
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text(title),
            floating: true,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                        switch (index) {
                          case 0: return Padding(padding: EdgeInsets.only(left: 16, right: 16), child: _buildSelectionStuff());
                          case 1: return Padding(padding: EdgeInsets.only(left: 16, right: 16), child: _buildUpdateButton());
                          case 2: return Padding(padding: EdgeInsets.only(left: 16, right: 8), child: _buildChart());
                          default: return null;
                        }
                    }
                    , childCount: 3
            ),
          )
        ],
      ),
    );
  }

  /// contains the button for picking the start date, the dropdown for selecting
  /// the period and the slider for setting the step size
  Widget _buildSelectionStuff() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 2),
              child: Text(AppLocalizations.of(context).date),
            ),
            FlatButton(
              child: Text(_formatDate(_mDateTime.toLocal()), style: TextStyle(fontWeight: FontWeight.bold),),
              textColor: Theme.of(context).primaryColor,
              onPressed: () {
                _showDatePicker();
              },
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: Text(AppLocalizations.of(context).period),
            ),
            DropdownButton<String>(
              value: _mSelectedPeriod,
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 24,
              elevation: 8,
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold
              ),
              onChanged: (String newValue) {
                setState(() {
                  _mSelectedPeriod = newValue;
                  //_mStepSelection = 0;
                });
              },
              items: _mPeriodList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildUpdateButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        RaisedButton(
          child: Text(AppLocalizations.of(context).update),
          onPressed: () {
            if (_mProgressDialog != null && !_mProgressDialog.isShowing()) {
              _mProgressDialog.show();
              _getChartData().then((map) {
                _updateChartData(map).then((value){
                  _mProgressDialog.dismiss();
                }).catchError((error) {
                  print(error);
                  _mProgressDialog.dismiss();
                  _showErrorAlert(error);
                });
              }).catchError((error){
                print(error);
                _mProgressDialog.dismiss();
                _showErrorAlert(error);
              });
            }
          },
          color: Theme.of(context).primaryColor,
          textColor: Colors.white,
        )
      ],
    );
  }

  /// TODO: initialSelection not really working
  /// ISSUE: select a value first then you can hide series (only in debug version necessary)
  Widget _buildChart() {
    /// different layout in portrait and landscape mode
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      List<charts.ChartBehavior> behaviors = [
        charts.SeriesLegend(
        position: charts.BehaviorPosition.top,
        horizontalFirst: true,
        desiredMaxColumns: 2,
        cellPadding: new EdgeInsets.only(right: 8.0, bottom: 4.0),
        showMeasures: true,
        legendDefaultMeasure: charts.LegendDefaultMeasure.firstValue,
        measureFormatter: (num value) {
          return value == null ? '-' : value.toInt().toString() + "°C";
        },
      ),
      charts.InitialSelection(
        selectedDataConfig: [
          charts.SeriesDatumConfig<DateTime>(mChartSeriesList[0].id, mChartSeriesList[0].data.first.timeCurrent),
          charts.SeriesDatumConfig<DateTime>(mChartSeriesList[1].id, mChartSeriesList[1].data.first.timeCurrent),
          charts.SeriesDatumConfig<DateTime>(mChartSeriesList[2].id, mChartSeriesList[2].data.first.timeCurrent),
          charts.SeriesDatumConfig<DateTime>(mChartSeriesList[3].id, mChartSeriesList[3].data.first.timeCurrent),
          charts.SeriesDatumConfig<DateTime>(mChartSeriesList[4].id, mChartSeriesList[4].data.first.timeCurrent),
          charts.SeriesDatumConfig<DateTime>(mChartSeriesList[5].id, mChartSeriesList[5].data.first.timeCurrent),
          charts.SeriesDatumConfig<DateTime>(mChartSeriesList[6].id, mChartSeriesList[6].data.first.timeCurrent),
        ]
      )];
      return _buildChartWidget(CHART_HEIGHT_PORTRAIT, behaviors);
    } else {
      List<charts.ChartBehavior> behaviors = [charts.SeriesLegend(
        position: charts.BehaviorPosition.top,
        horizontalFirst: true,
        desiredMaxColumns: 4,
        cellPadding: new EdgeInsets.only(right: 8.0, bottom: 4.0),
        showMeasures: true,
        legendDefaultMeasure: charts.LegendDefaultMeasure.firstValue,
        measureFormatter: (num value) {
          return value == null ? '-' : value.toInt().toString() + "°C";
        },
      ),
      charts.InitialSelection(
          selectedDataConfig: [
            charts.SeriesDatumConfig<DateTime>(mChartSeriesList[0].id, mChartSeriesList[0].data.first.timeCurrent),
            charts.SeriesDatumConfig<DateTime>(mChartSeriesList[1].id, mChartSeriesList[1].data.first.timeCurrent),
            charts.SeriesDatumConfig<DateTime>(mChartSeriesList[2].id, mChartSeriesList[2].data.first.timeCurrent),
            charts.SeriesDatumConfig<DateTime>(mChartSeriesList[3].id, mChartSeriesList[3].data.first.timeCurrent),
            charts.SeriesDatumConfig<DateTime>(mChartSeriesList[4].id, mChartSeriesList[4].data.first.timeCurrent),
            charts.SeriesDatumConfig<DateTime>(mChartSeriesList[5].id, mChartSeriesList[5].data.first.timeCurrent),
            charts.SeriesDatumConfig<DateTime>(mChartSeriesList[6].id, mChartSeriesList[6].data.first.timeCurrent),
          ]
      )];
      return _buildChartWidget(CHART_HEIGHT_LANDSCAPE, behaviors);
    }
  }

  Widget _buildChartWidget(double height, List<charts.ChartBehavior> behaviors) {
    return Padding(
        padding: EdgeInsets.only(bottom: 8, top: 8),
        child: Container(
            height: height,
            width: MediaQuery.of(context).size.width,
            child: charts.TimeSeriesChart(
              mChartSeriesList,
              animate: true,
              domainAxis: _getDomainAxisSpec(),
              primaryMeasureAxis: _getPrimaryAxisSpec(),
              behaviors: behaviors,
            )
        )
    );
  }

  charts.NumericAxisSpec _getPrimaryAxisSpec() {
    return charts.NumericAxisSpec(
        tickFormatterSpec: charts.BasicNumericTickFormatterSpec((num value) {
          return (value!=null ? value.toInt().toString() + "°C" : "");
        })
    );
  }

  charts.DateTimeAxisSpec _getDomainAxisSpec() {
    return charts.DateTimeAxisSpec(
        tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
          minute: charts.TimeFormatterSpec(format: 'HH:mm', transitionFormat: "HH:mm", noonFormat: "HH:mm"),
          hour: charts.TimeFormatterSpec(format: 'HH:mm', transitionFormat: "HH:mm", noonFormat: "HH:mm"),
          day: charts.TimeFormatterSpec(format: 'dd.', transitionFormat: "dd.MM", noonFormat: "dd.MM"),
        )
    );
  }

  /// build the progress dialog which will be shown when the user hits the
  /// update button
  void _buildProgressDialog() {
    _mProgressDialog = ProgressDialog(context,
        type: ProgressDialogType.Normal,
        isDismissible: false,
        showLogs: false
    );
    _mProgressDialog.style(
        message: AppLocalizations.of(context).downloadData,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        insetAnimCurve: Curves.easeInOut,
        progressTextStyle: TextStyle(
            color: Theme.of(context).accentColor),
    );
  }

  /// format date into a nice way
  String _formatDate(DateTime dateTime) {
    DateFormat dateFormat = DateFormat("d. MMMM yyyy   HH:mm",
        Localizations.localeOf(context).languageCode);
    return dateFormat.format(dateTime);
  }

  /// pick date since we want to view the values
  void _showDatePicker() async {
    DatePicker.showDateTimePicker(
        context,
        showTitleActions: true,
        minTime: DateTime(2019, 12, 1),
        currentTime: DateTime.now().toLocal(),
        maxTime: DateTime.now().toLocal(),
        onChanged: (date) {
          // nothing to do
        }, onConfirm: (date) {
          setState(() {
            _mDateTime = date;
          });
        },
        locale: _getLocalType(),
    );
  }

  /// needed for the date picker
  LocaleType _getLocalType() {
    switch(Localizations.localeOf(context).languageCode) {
      case "en": return LocaleType.en;
      case "de": return LocaleType.de;
      default: return LocaleType.en;
    }
  }

  /// called when user wants new data
  Future<MeasurementSeries> _getChartData() async {
    // transform period to minutes
    int period = 0;
    switch(_mSelectedPeriod) {
      case "1h": period = 60; break;
      case "2h": period = 60*2; break;
      case "4h": period = 60*4; break;
      case "12h": period = 60*12; break;
      case "1d": period = 60*24; break;
      default: period = 60; break;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(PREF_DEMO_MODE)) {
      if (prefs.getBool(PREF_DEMO_MODE) == true) {
        // demo mode
        return TestDataMaker.getRandomHistoryDataDelayed(2, _mDateTime, 5, period);
      }
    }
    // prod mode
    return NetworkManager.fetchSeries(_mDateTime.subtract(Duration(minutes: period)).toUtc(), _mDateTime.toUtc());
  }

  /// init the chart with the values from the main page which are passed via
  /// the constructor. If they are null zero will be taken as value
  void _initChart() {
    // init list
    mChartSeriesList = List(NUMBER_OF_DISPLAYED_VALUES);
    // generate init data
    List<List<TimeSeriesHistory>> initValues;
    if (widget.mInitialValues != null) {
      initValues = [
        [TimeSeriesHistory(timeCurrent: widget.mInitialValues.time, value: widget.mInitialValues.tempPipe)],
        [TimeSeriesHistory(timeCurrent: widget.mInitialValues.time, value: widget.mInitialValues.tempSupply)],
        [TimeSeriesHistory(timeCurrent: widget.mInitialValues.time, value: widget.mInitialValues.tempBoiler)],
        [TimeSeriesHistory(timeCurrent: widget.mInitialValues.time, value: widget.mInitialValues.tempP1)],
        [TimeSeriesHistory(timeCurrent: widget.mInitialValues.time, value: widget.mInitialValues.tempP2)],
        [TimeSeriesHistory(timeCurrent: widget.mInitialValues.time, value: widget.mInitialValues.tempP3)],
        [TimeSeriesHistory(timeCurrent: widget.mInitialValues.time, value: widget.mInitialValues.tempP4)],
      ];
    } else {
      DateTime currentTime = DateTime.now();
      initValues = [
        [TimeSeriesHistory(timeCurrent: currentTime, value: 0)],
        [TimeSeriesHistory(timeCurrent: currentTime, value: 0)],
        [TimeSeriesHistory(timeCurrent: currentTime, value: 0)],
        [TimeSeriesHistory(timeCurrent: currentTime, value: 0)],
        [TimeSeriesHistory(timeCurrent: currentTime, value: 0)],
        [TimeSeriesHistory(timeCurrent: currentTime, value: 0)],
        [TimeSeriesHistory(timeCurrent: currentTime, value: 0)]
      ];
    }
    /// add chart series to list
    for (int i=0; i<NUMBER_OF_DISPLAYED_VALUES; i++) {
      mChartSeriesList[i] = _createSeriesListEntry(
          mappedChartsStyling[i][KEY_MAP_ID],
          mappedChartsStyling[i][KEY_MAP_COLOR],
          initValues[i]);
    }
  }

  /// update the chart only if we have values
  /// values of the [map] = List<TimeSeriesHistory>
  Future<void> _updateChartData(MeasurementSeries measurementSeries) async {
    if (measurementSeries.measurements.length != 0) {
      List<List<TimeSeriesHistory>> data = [
        List(),
        List(),
        List(),
        List(),
        List(),
        List(),
        List()
      ];

      for (Measurement measurement in measurementSeries.measurements) {
        data[0].add(TimeSeriesHistory(timeCurrent: measurement.time, value: measurement.tempPipe));
        data[1].add(TimeSeriesHistory(timeCurrent: measurement.time, value: measurement.tempSupply));
        data[2].add(TimeSeriesHistory(timeCurrent: measurement.time, value: measurement.tempBoiler));
        data[3].add(TimeSeriesHistory(timeCurrent: measurement.time, value: measurement.tempP1));
        data[4].add(TimeSeriesHistory(timeCurrent: measurement.time, value: measurement.tempP2));
        data[5].add(TimeSeriesHistory(timeCurrent: measurement.time, value: measurement.tempP3));
        data[6].add(TimeSeriesHistory(timeCurrent: measurement.time, value: measurement.tempP4));
      }

      setState(() {
        // reset list
        mChartSeriesList = List(NUMBER_OF_DISPLAYED_VALUES);
        // add new values
        for (int i=0; i<NUMBER_OF_DISPLAYED_VALUES; i++) {
          mChartSeriesList[i] = _createSeriesListEntry(
              mappedChartsStyling[i][KEY_MAP_ID],
              mappedChartsStyling[i][KEY_MAP_COLOR],
              data[i],
              displayName: _mChartDisplayNames[i]);
        }
      });
    }
    return null;
  }

  /// Creates a chart series
  /// Define the line color with [color]
  /// [data] is a list of values: x-axis = time, y-axis = temp or state
  /// The [displayName] parameter is optional, default = ""
  charts.Series<TimeSeriesHistory, DateTime> _createSeriesListEntry(
      String id,
      charts.Color color,
      List<TimeSeriesHistory> data,
      {String displayName=""}) {
    return charts.Series<TimeSeriesHistory, DateTime>(
      id: id,
      colorFn: (_, __) => color,
      domainFn: (TimeSeriesHistory value, _) => value.timeCurrent,
      measureFn: (TimeSeriesHistory value, _) => value.value,
      data: data,
      displayName: displayName
    );
  }

  /// display name = name of series in legend
  /// needs to be called after widgets are build and build context is valid
  _setChartDisplayNames() {
    AppLocalizations appLocalizations = AppLocalizations.of(context);
    _mChartDisplayNames = [
      appLocalizations.pipe,
      appLocalizations.supply,
      appLocalizations.boiler,
      appLocalizations.p1,
      appLocalizations.p2,
      appLocalizations.p3,
      appLocalizations.p4
    ];
  }

  /// displays an error alert
  void _showErrorAlert(String error) {
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
  }
}

class TimeSeriesHistory {
  final DateTime timeCurrent;
  final int value;

  TimeSeriesHistory({this.timeCurrent, this.value});
}
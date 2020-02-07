import 'dart:math';
import 'package:heating_controller/utility/networkManager.dart';
import 'constants.dart';

class TestDataMaker {

  static Future<Measurement> getRandomDataDelayed(int delay) {
    return Future<Measurement>.delayed(Duration(seconds: delay), () {
      Random random = Random();
      return Measurement(
        time: DateTime.now(),
        tempPipe: random.nextInt(MAX_TEMP),
        tempP1: random.nextInt(MAX_TEMP),
        tempP2: random.nextInt(MAX_TEMP),
        tempP3: random.nextInt(MAX_TEMP),
        tempP4: random.nextInt(MAX_TEMP),
        tempSupply: random.nextInt(MAX_TEMP),
        tempBoiler: random.nextInt(MAX_TEMP),
        hatchState: random.nextBool()
      );
    });
  }

  static Future<MeasurementSeries> getRandomHistoryDataDelayed(int delay, DateTime currentTime, int step, int period) {
    return Future<MeasurementSeries>.delayed(Duration(seconds: delay), () {
      Random random = Random();
      DateTime endTime = currentTime.subtract(Duration(minutes: period));

      List<Measurement> measurements = List();

      while (currentTime.isAfter(endTime)) {
        measurements.add(Measurement(
          time: currentTime,
          tempPipe: random.nextInt(MAX_TEMP),
          tempP1: random.nextInt(MAX_TEMP),
          tempP2: random.nextInt(MAX_TEMP),
          tempP3: random.nextInt(MAX_TEMP),
          tempP4: random.nextInt(MAX_TEMP),
          tempSupply: random.nextInt(MAX_TEMP),
          tempBoiler: random.nextInt(MAX_TEMP),
          hatchState: random.nextBool()
        ));
        currentTime = currentTime.subtract(Duration(minutes: step));
      }

      return MeasurementSeries(measurements: measurements);
    });
  }
}
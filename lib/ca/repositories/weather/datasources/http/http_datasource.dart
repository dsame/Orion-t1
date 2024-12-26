import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

import '../../models/measurement.dart';
import '../measurements_datasource.dart';

/// The implementation of the MeasurementsDatasource that gets the data from the
/// HTTP API and generates the data for the week based on the data of the day
/// using the injected random number generator
class HttpDatasource extends MeasurementsDatasource {
  final Random _rnd;
  final http.Client _client;

  HttpDatasource(this._rnd, this._client);

  /// see [MeasurementsDatasource.get]
  /// TODO: error handling
  @override
  Future<List<MeasurementModel>> get(DateTime from, DateTime to) async {
    final result = await _client
        .get(Uri.parse('http://example.com/measurements?from=$from&to=$to'));
    if (result.statusCode == 200) {
      final jsonString = result.body;
      // do not use (de)serialization, as the data is not guaranteed to be correct
      List<dynamic> jsonDay = jsonDecode(jsonString);
      // get one day of measurements (list of hour measurements)
      // to be used as a seed for week data generation
      List<MeasurementModel> seedMeasurements = jsonDay
          .map((e) => _map2Measurement(e))
          .where((element) => element != null)
          .map((e) => e!)
          .toList(growable: false);

      // generate
      List<List<MeasurementModel>> measurements =
          // 7 days of measurements
          List<List<MeasurementModel>>.generate(7, (i) {
        // where each day is a list of
        List<MeasurementModel> dayMeasurements = List<MeasurementModel>.generate(
            // the same number of hours as the previous (seed) day
            seedMeasurements.length,
            // and each hour is a generated as random variation of the
            // same hour of the previous day
            (hour) => generateMockMeasurement(seedMeasurements[hour]));
        seedMeasurements = dayMeasurements;
        return dayMeasurements;
      });

      // flatten the list, as the API expects a list of measurements
      return measurements.expand((element) => element).toList();
    }
    return <MeasurementModel>[];
  }

  /// Generates a mock measurement based on the last one
  /// @param seed the last measurement
  /// @returns the new measurement
  MeasurementModel generateMockMeasurement(MeasurementModel seed) {
    int randomMinutes = _rnd.nextInt(16);
    // next day, same hour, random minutes
    DateTime timestamp = DateTime(seed.timestamp.year, seed.timestamp.month,
        seed.timestamp.day + 1, seed.timestamp.hour, randomMinutes, 0);
    // temperature +- 30%
    double temperature =
        seed.temperature + (_rnd.nextDouble() - 0.5) * seed.temperature * 0.3;
    // wind speed +- 20%
    int windSpeed = max(
        0,
        (seed.windSpeed + (_rnd.nextDouble() - 0.5) * seed.windSpeed * 0.2)
            .toInt());
    int windDirection =
        max(0, seed.windDirection + _rnd.nextInt(180) - 90) % 360;
    // precipitation +- 50%
    double precipitation = max(
        0,
        seed.precipitation +
            (_rnd.nextDouble() - 0.5) * seed.precipitation * 0.5);

    return MeasurementModel(
      timestamp: timestamp,
      temperature: temperature,
      windSpeed: windSpeed,
      windDirection: windDirection,
      precipitation: precipitation,
    );
  }

  /// Maps the json data to the MeasurementBean
  /// @returns null if the data is wrong
  /// TODO: log wrong data?
  static MeasurementModel? _map2Measurement(Map<String, dynamic> json) {
    DateTime? timestamp;
    switch (json['timeStamp']) {
      case String s:
        timestamp = DateTime.tryParse(s);
        break;
      default:
        return null;
    }
    if (timestamp == null) return null;

    double? temperature;
    switch(json['temperature']) {
      case int i:
        temperature = i.toDouble();
        break;
      case double d:
        temperature = d;
        break;
      case String s:
        temperature = double.tryParse(s);
        break;
      default:
        return null;
    }
    if (temperature == null) return null;

    Map<String, dynamic>? wind = json['wind'];
    if (wind == null) return null;

    int? windSpeed;
    switch(wind['speed']) {
      case int i:
        windSpeed = i;
        break;
      case double d:
        windSpeed = d.toInt();
        break;
      case String s:
        windSpeed = int.tryParse(s);
        break;
      default:
        return null;
    }
    if (windSpeed == null) return null;

    int? windDirection;
    switch(wind['direction']) {
      case int i:
        windDirection = i;
        break;
      case double d:
        windDirection = d.toInt();
        break;
      case String s:
        windDirection = int.tryParse(s);
        break;
      default:
        return null;
    }
    if (windDirection == null) return null;

    double? precipitation;
    switch(json['rainfall']) {
      case int i:
        precipitation = i.toDouble();
        break;
      case double d:
        precipitation = d;
        break;
      case String s:
        precipitation = double.tryParse(s);
        break;
      default:
        return null;
    }
    if (precipitation == null) return null;

    return MeasurementModel(
      timestamp: timestamp,
      temperature: temperature,
      windSpeed: windSpeed,
      windDirection: windDirection,
      precipitation: precipitation,
    );
  }
}

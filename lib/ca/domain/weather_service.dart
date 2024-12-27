///  This class defines the interface for all the measurements providers
///  that will be used to get the measurements data from the different sources
///
///   The API is assumed to be as simple as possible, and not to be responsible
///   for providing correct data, but to provide the data as it is.
library weather_repository;

import 'dart:collection';

import 'package:main/ca/domain/weather_entities.dart';
import 'package:main/ca/repositories/weather/weather_repository.dart';

/// Incorporate the providers and expose use cases
class WeatherService {
  final WeatherRepository _weatherRepository;

  WeatherService(this._weatherRepository);

  // fetches the measurements for the last 7 days
  // and converts the repository model to the domain entity
  // @returns the list of MinMaxTemperature
  //          with some days missing if there is no data
  Future<List<MinMaxTemperature>> getMinMaxTemperatureLast7Days() async {
    return (await _weatherRepository
            .getMinMaxTemperatureGroupByDateForLast7Days())
        .map((pair) {
      final min = pair.second.first;
      final max = pair.second.second;
      return MinMaxTemperature(pair.first, min, max);
    }).toList();
  }

  // Fetches the measurements for the last 7 days
  // and calculates the wind rouse for each day based on the number of measurements
  // Speed is not taken into account
  // @returns the wind rose for the week
  Future<Map<WindDirection, int>> getWindRoseLast7Days() async {
    final measurements = await _weatherRepository.getMeasurementsForLast7Days();

    Map<WindDirection, int> windRose = HashMap();
    for (var measurement in measurements) {
      final direction = WindDirectionExt.fromDegrees(measurement.windDirection);
      windRose[direction] = (windRose[direction] ?? 0) + 1;
    }

    return Map.unmodifiable(windRose);
  }

  // Fetches the measurements for the last 7 days grouped by a day
  // and calculates the total amount of precipitation for each day
  // @returns the total amount of precipitation for each day
  Future<List<DayPrecipitation>> getTotalPrecipitationLast7Days() async {
    return (await _weatherRepository.getMeasurementGroupByDateForLast7Days())
        .map((pair) {
      final day = pair.first;
      final measurements = pair.second;
      final totalPrecipitation = measurements.fold<double>(
          0, (previousValue, element) => previousValue + element.precipitation);
      return DayPrecipitation(day, totalPrecipitation);
    }).toList();
  }
}

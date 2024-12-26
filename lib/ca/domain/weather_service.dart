///  This class defines the interface for all the measurments providers
///  that will be used to get the measurments data from the different sources
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
  // and calculates the min and max temperature for each day
  // @returns the list of MinMaxTemperature
  //          with some days missing if there is no data
  Future<Map<DayOfWeek, MinMaxTemperature>>
      getMinMaxTemperatureLast7Days() async {
    final measurements = await _weatherRepository.getMeasurementsForLast7Days();

    // 1st step: group by day of the week and find min and max temperature
    //           as a list of 2 elements [min, max]
    // 2st step: convert to the map with MinMaxTemperature
    // Reasoning for the 2 steps: MinMaxTemperature is an immutable class
    // and thus has to be allocated on each update, while the intermediate
    // lists of min/max temperatures can be updated in place

    // map day->(min, max) is represented as a list of 14 elements [min1, max1, min2, max2, ...]
    List dayToMinMax = List.generate(14,
        (index) => index % 2 == 0 ? double.infinity : double.negativeInfinity);
    for (var measurement in measurements) {
      final temperature = measurement.temperature;
      final dayOfWeek = measurement.timestamp.weekday;
      final dayOffset = (dayOfWeek - 1) * 2;
      if (temperature < dayToMinMax[dayOffset]) {
        dayToMinMax[dayOffset] = temperature;
      }
      if (temperature > dayToMinMax[dayOffset + 1]) {
        dayToMinMax[dayOffset + 1] = temperature;
      }
    }

    // 2nd step
    return Map.unmodifiable(Map.fromEntries(
      List.generate(7, (index) {
        final dayOfWeek = DayOfWeekExt.fromIntZero(index);
        return MapEntry(
          dayOfWeek,
          MinMaxTemperature(
            dayToMinMax[index * 2],
            dayToMinMax[index * 2 + 1],
          ),
        );
      }),
    ));
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

  // Fetches the measurements for the last 7 days
  // and calculates the total amount of precipitation for each day
  // @returns the total amount of precipitation for each day
  Future<Map<DayOfWeek, double>> getTotalPrecipitationLast7Days() async {
    final measurements = await _weatherRepository.getMeasurementsForLast7Days();

    List<double> dayToPrecipitation = List.filled(7, 0);
    for (var measurement in measurements) {
      final dayOfWeek = measurement.timestamp.weekday - 1;
      dayToPrecipitation[dayOfWeek] += measurement.precipitation;
    }

    return Map.unmodifiable(Map.fromEntries(
      List.generate(7, (index) {
        return MapEntry(
          DayOfWeekExt.fromIntZero(index),
          dayToPrecipitation[index],
        );
      }),
    ));
  }
}

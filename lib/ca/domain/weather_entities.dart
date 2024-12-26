///  This class defines the interface for all the measurments providers
///  that will be used to get the measurments data from the different sources
///
///   The API is assumed to be as simple as possible, and not to be responsible
///   for providing correct data, but to provide the data as it is.
library weather_repository;

enum DayOfWeek { MON, TUE, WED, THU, FRI, SAT, SUN }

extension DayOfWeekExt on DayOfWeek {
  static DayOfWeek fromIntZero(int day) {
    return DayOfWeek.values[day];
  }
}

class MinMaxTemperature {
  final double min;
  final double max;

  MinMaxTemperature(this.min, this.max);
}

enum WindDirection { N, NE, E, SE, S, SW, W, NW }

extension WindDirectionExt on WindDirection {
  static WindDirection fromDegrees(int degrees) {
    final index = ((degrees + 22.5) % 360) ~/ 45;
    return WindDirection.values[index];
  }
}

class WindRose {
  final double direction;
  final double strength;

  WindRose(this.direction, this.strength);
}
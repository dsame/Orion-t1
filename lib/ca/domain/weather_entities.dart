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
  static DayOfWeek fromDateTime(DateTime date) {
    return DayOfWeek.values[date.weekday - 1];
  }
  String toShortLabel() {
    switch(this) {
      case DayOfWeek.MON:
        return 'Mon';
      case DayOfWeek.TUE:
        return 'Tue';
      case DayOfWeek.WED:
        return 'Wed';
      case DayOfWeek.THU:
        return 'Thu';
      case DayOfWeek.FRI:
        return 'Fri';
      case DayOfWeek.SAT:
        return 'Sat';
      case DayOfWeek.SUN:
        return 'Sun';
    }
  }
}

class MinMaxTemperature {
  final DateTime day;
  final double min;
  final double max;

  MinMaxTemperature(this.day, this.min, this.max);
}

class DayPrecipitation {
  final DateTime day;
  final double precipitation;

  DayPrecipitation(this.day, this.precipitation);
}

enum WindDirection { N, NE, E, SE, S, SW, W, NW }

extension WindDirectionExt on WindDirection {
  static WindDirection fromDegrees(int degrees) {
    final index = ((degrees + 22.5) % 360) ~/ 45;
    return WindDirection.values[index];
  }

  String toShortLabel() {
    switch(this) {
      case WindDirection.N:
        return 'N';
      case WindDirection.NE:
        return 'NE';
      case WindDirection.E:
        return 'E';
      case WindDirection.SE:
        return 'SE';
      case WindDirection.S:
        return 'S';
      case WindDirection.SW:
        return 'SW';
      case WindDirection.W:
        return 'W';
      case WindDirection.NW:
        return 'NW';
    }
  }
}

class WindRose {
  final double direction;
  final double strength;

  WindRose(this.direction, this.strength);
}

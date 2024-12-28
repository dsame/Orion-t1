class MeasurementModel {
  final DateTime timestamp;
  final double temperature;
  final double windSpeed;
  final int windDirection;
  final double precipitation;

  MeasurementModel({
    required this.timestamp,
    required this.temperature,
    required this.windSpeed,
    required this.windDirection,
    required this.precipitation,
  });
}
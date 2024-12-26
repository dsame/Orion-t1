///  This class defines the interface for all the measurments providers
///  that will be used to get the measurments data from the different sources
///
///   The API is assumed to be as simple as possible, and not to be responsible
///   for providing correct data, but to provide the data as it is.
library weather_repository;

import 'datasources/measurements_datasource.dart';
import 'models/measurement.dart';

/// Overengineering, for demonstration purposes and possible future extensions
class WeatherRepository {
  final MeasurementsDatasource _measurementsProvider;

  WeatherRepository(this._measurementsProvider);

  Future<List<MeasurementModel>> getMeasurementsForLast7Days() async {
    return _measurementsProvider.get(DateTime.now().subtract(const Duration(days: 7)), DateTime.now());
  }
}

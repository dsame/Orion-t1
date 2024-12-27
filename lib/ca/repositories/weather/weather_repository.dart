///  This class defines the interface for all the measurments providers
///  that will be used to get the measurments data from the different sources
///
///   The API is assumed to be as simple as possible, and not to be responsible
///   for providing correct data, but to provide the data as it is.
library weather_repository;

import '../../../types/pair.dart';
import 'datasources/measurements_datasource.dart';
import 'models/measurement.dart';

// TODO:
// adds local cache for datasource to avoid multiple requests
class WeatherRepository {
  final MeasurementsDatasource _measurementsProvider;

  WeatherRepository(this._measurementsProvider);

  Future<List<MeasurementModel>> getMeasurementsForLast7Days() async {
    return _measurementsProvider.get(
        DateTime.now().subtract(const Duration(days: 7)), DateTime.now());
  }

  Future<List<Pair<DateTime, List<MeasurementModel>>>> getMeasurementGroupByDateForLast7Days() {
    return _measurementsProvider.getGroupByDate(
        DateTime.now().subtract(const Duration(days: 7)), DateTime.now());
  }

  Future<List<Pair<DateTime, Pair<double, double>>>>
      getMinMaxTemperatureGroupByDateForLast7Days() {
    return _measurementsProvider.getMinMaxTemperatureGroupByDate(
        DateTime.now().subtract(const Duration(days: 7)), DateTime.now());
  }
}

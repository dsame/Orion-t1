import '../models/measurement.dart';

///  This class defines the interface for all the measurments providers
///  that will be used to get the measurments data from the different sources
///
///   The API is assumed to be as simple as possible, and not to be responsible
///   for providing correct data, but to provide the data as it is.
///


/// The interface for the measurements provider
/// assumed to be as simple as possible, and not to be responsible
abstract class MeasurementsDatasource {
  /// Get the measurements data from the source
  /// @param from the start date - currently not used
  /// @param to the end date - currently not used
  /// @returns the list of measurements
  Future<List<MeasurementModel>> get(DateTime from, DateTime to);
}

// It can be a function but for consistency it is implemented as a Widget
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'ca/domain/weather_service.dart';
import 'ca/repositories/weather/datasources/http/asset_client.dart';
import 'ca/repositories/weather/datasources/http/http_datasource.dart';
import 'ca/repositories/weather/datasources/measurements_datasource.dart';
import 'ca/repositories/weather/weather_repository.dart';

class AppDependenciesProvider extends StatelessWidget {
  final Widget child;

  const AppDependenciesProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final http.Client client = AssetClient(Random(100));
    final MeasurementsDatasource measurementsDatasource =
        HttpDatasource(Random(100), client);
    final WeatherRepository weatherRepository =
        WeatherRepository(measurementsDatasource);
    final WeatherService weatherService = WeatherService(weatherRepository);

    return MultiProvider(
      providers: [
        Provider.value(value: weatherService),
      ],
      child: child,
    );
  }
}

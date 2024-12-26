import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:main/ca/repositories/weather/datasources/http/http_datasource.dart';
import 'package:main/ca/repositories/weather/models/measurement.dart';
import 'package:mockito/annotations.dart';


@GenerateMocks([http.Client])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('HttpProviderTest.get should return list of MeasurementBeans', () async {
    //Arrange
    final rnd = Random(100);
    final client = MockClient((request) async {
      final jsonString = await rootBundle.loadString('assets/sample_1d.json');
      return http.Response(jsonString, 200);
    });

    //Act
    final httpProvider = HttpDatasource(rnd, client);
    final measurements = await httpProvider.get(DateTime(2022, 1, 1), DateTime(2022, 1, 2));

    //Assert
    expect(measurements, isA<List<MeasurementModel>>());
  });
}
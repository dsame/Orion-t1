import 'dart:convert';
import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:main/ca/repositories/weather/datasources/http/asset_client.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('AssetMock.get should return JSON parseable string', () async {
    //arrange
    final rnd = Random(100);
    final assetMock = AssetClient(rnd);
    // act
    final result = await assetMock.get(Uri.parse(
        'http://example.com/measurements?from=2022-01-01&to=2022-01-02'));
    // assert
    expect(result.statusCode, 200);
    expect(result.body, isA<String>());
    List<dynamic> jsonDay = jsonDecode(result.body);
    expect(jsonDay, isA<List<dynamic>>());
    expect(jsonDay.length, 24);
  });
}

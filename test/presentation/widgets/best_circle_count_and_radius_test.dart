import 'package:flutter_test/flutter_test.dart';
import 'package:main/presentation/widgets/radar_chart.dart';
import 'package:main/types/pair.dart';

void main() {
  const testCases = [
    Pair(28.0, Pair(6, 30)), // best match for 28 is 6 circles with outer radius 30
    Pair(20.0, Pair(4, 20)), // best match for 20 is 4 circles with outer radius 20
  ];
  for (var testCase in testCases) {
    final double value = testCase.first;
    final expectedCircleCount = testCase.second.first;
    final expectedOuterRadius = testCase.second.second;

    test('for $value, should be $expectedCircleCount circles, with  outer radius = ${expectedOuterRadius}', () {
      //Arrange
      //Act
      final result = bestCircleCountAndOuterRadius(value);
      //Assert
      expect(result.first, expectedCircleCount);
      expect(result.second, expectedOuterRadius);
    });
  }
}
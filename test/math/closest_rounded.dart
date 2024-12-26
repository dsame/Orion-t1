import 'package:flutter_test/flutter_test.dart';
import 'package:main/math/closest_rounded.dart';

void main() {
  const testCases = [
    [9, 5, 10], // 9/5 = 1.8, closes good number is 2, so result is 5 * 2 = 10
    [78, 5, 100], // 78 / 5 = 15.6, closest good number is 20 so result is 5 * 20 = 100
    [80, 5, 100], // 80 / 5 = 16, closest good number is 20 so result is 5 * 20 = 100
    [93, 10, 100], // 93 / 100 = 9.3, closest good number is 10 so result is 10 * 10 = 100
    [93, 5, 100], // 93 / 5 = 18.6, closest good number is 20 so result is 5 * 20 = 100
    [160, 5, 200], // 160 / 5 = 32, closest good number is 40 so result is 5 * 40 = 200
    [170, 5, 200], // 170 / 5 = 34, closest good number is 40 so result is 5 * 50 = 200
  ];
  for (var testCase in testCases) {
    test('closestRounded(${testCase[0]}, ${testCase[1]}) should be ${testCase[2]}', () {
      //Arrange
      //Act
      final result = closestRoundedNumber(testCase[0].toDouble(), testCase[1] as int);
      //Assert
      expect(result, testCase[2] as int);
    });
  }
}
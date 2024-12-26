import 'package:flutter_test/flutter_test.dart';
import 'package:main/ca/domain/weather_entities.dart';

void main() {
  group('DayOfWeek', () {
    const testCases = [
      [0, DayOfWeek.MON],
      [1, DayOfWeek.TUE],
      [2, DayOfWeek.WED],
      [3, DayOfWeek.THU],
      [4, DayOfWeek.FRI],
      [5, DayOfWeek.SAT],
      [6, DayOfWeek.SUN],
    ];

    for (var testCase in testCases) {
      test('[${testCase[1]}] should be made from int[${testCase[0]}]', () {
        //Arrange
        //Act
        final dayOfWeek = DayOfWeekExt.fromIntZero(testCase[0] as int);
        //Assert
        expect(dayOfWeek, testCase[1] as DayOfWeek);
      });
    }
  });

  group('WindDirection', () {
    const testCases = [
      [338, WindDirection.N],
      [360, WindDirection.N],
      [0, WindDirection.N],
      [22, WindDirection.N],
      [23, WindDirection.NE],
      [45, WindDirection.NE],
      [67, WindDirection.NE],
      [68, WindDirection.E],
      [90, WindDirection.E],
      [112, WindDirection.E],
      [113, WindDirection.SE],
      [135, WindDirection.SE],
      [157, WindDirection.SE],
      [158, WindDirection.S],
      [180, WindDirection.S],
      [202, WindDirection.S],
      [203, WindDirection.SW],
      [225, WindDirection.SW],
      [247, WindDirection.SW],
      [248, WindDirection.W],
      [270, WindDirection.W],
      [292, WindDirection.W],
      [293, WindDirection.NW],
      [315, WindDirection.NW],
      [337, WindDirection.NW],
    ];

    for (var testCase in testCases) {
      test('[${testCase[1]}] should be made from degrees[${testCase[0]}]', () {
        //Arrange
        //Act
        final windDirection = WindDirectionExt.fromDegrees(testCase[0] as int);
        //Assert
        expect(windDirection, testCase[1] as WindDirection);
      });
    }
  });
}

final _goodNumbers = [1, 2, 5, 10, 20, 40, 50, 100, 150, 200, 250, 500, 1000];

int _closestGoodNumber(double value) {
  for (var i = 1; i < _goodNumbers.length; i++) {
    if (_goodNumbers[i] > value) {
      return _goodNumbers[i];
    }
  }
  return _goodNumbers.last;
}
/// Returns the closest "good" number to [value] that is a multiple of [divisions]
/// Used for wind rouse diagram to calculate the radius of the circles
int closestRoundedNumber(double value, int divisions) {
  final double interval = value / divisions;
  final int closestGoodNumber = _closestGoodNumber(interval);
  return closestGoodNumber * divisions;
}
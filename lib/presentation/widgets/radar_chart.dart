import 'dart:math';

import 'package:flutter/material.dart';

import '../../ca/domain/weather_entities.dart';
import '../../types/pair.dart';

const _H_SPACE = 6;
const PADDING = 40;

class RadarChartWidget extends StatelessWidget {
  final Map<WindDirection, double> _data;
  late final int _circleCount;
  late final int _circleOuterRadius;
  final String Function(double)? _formatRadius;
  final String Function(double)? _formatVertex;

  RadarChartWidget(
      {super.key,
      required Map<WindDirection, double> data,
      formatRadius,
      formatVertex})
      : _data = sanitizeData(data),
        _formatRadius = formatRadius,
        _formatVertex = formatVertex {
    final params = bestCircleCountAndOuterRadius(_data.values.reduce(max));
    _circleCount = params.first;
    _circleOuterRadius = params.second;
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(300, 300),
      painter: _RadarPainter(_data, _circleCount, _circleOuterRadius,
          formatRadius: _formatRadius, formatVertex: _formatVertex),
    );
  }

  static Map<WindDirection, double> sanitizeData(
      Map<WindDirection, double> data) {
    Map<WindDirection, double> sanitizedData = {
      WindDirection.N: data[WindDirection.N] ?? 0.0,
      WindDirection.NE: data[WindDirection.NE] ?? 0.0,
      WindDirection.E: data[WindDirection.E] ?? 0.0,
      WindDirection.SE: data[WindDirection.SE] ?? 0.0,
      WindDirection.S: data[WindDirection.S] ?? 0.0,
      WindDirection.SW: data[WindDirection.SW] ?? 0.0,
      WindDirection.W: data[WindDirection.W] ?? 0.0,
      WindDirection.NW: data[WindDirection.NW] ?? 0.0,
    };
    return sanitizedData;
  }
}

// TODO: strength = 160 causes 1 extra circle
class _RadarPainter extends CustomPainter {
  final Map<WindDirection, double> _data;
  late final int _circleCount;
  late final int _circleOuterRadius;
  final String Function(double)? _formatRadius;
  final String Function(double)? _formatVertex;

  _RadarPainter(data, circleCount, circleOuterRadius,
      {formatRadius, formatVertex})
      : _data = data,
        _formatRadius = formatRadius,
        _formatVertex = formatVertex,
        _circleCount = circleCount,
        _circleOuterRadius = circleOuterRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final Paint fillPaint = Paint()
      ..color = Colors.blue.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    final labelPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    const chartLabelStyle = TextStyle(color: Colors.black, fontSize: 14);
    const vertexLabelStyle = TextStyle(color: Colors.red, fontSize: 12);

    // geometry dimensions
    final double radius = min(size.width, size.height) / 2 - PADDING;
    final Offset center = Offset(size.width / 2, size.height / 2);

    // Drawing circles
    for (int i = 1; i <= _circleCount; i++) {
      final double currentRadius = radius * i / _circleCount;

      final circlePaint = Paint()
        ..color = Colors.grey.withOpacity(0.5)
        ..style = PaintingStyle.stroke;

      canvas.drawCircle(center, currentRadius, circlePaint);

      if (_formatRadius != null) {
        final label = _formatRadius(_circleOuterRadius * i / _circleCount);
        // label each circle
        final labelCirclePainter = TextPainter(
          text: TextSpan(
            text: label,
            style: chartLabelStyle,
          ),
          textDirection: TextDirection.ltr,
        );
        labelCirclePainter.layout(minWidth: 0, maxWidth: size.width);
        labelCirclePainter.paint(
          canvas,
          Offset(center.dx - labelCirclePainter.width - _H_SPACE,
              center.dy - currentRadius - labelCirclePainter.height / 2 + 2),
        );
      }
    }

    // drawing the radar labels
    labelPainter.text = const TextSpan(
      text: "WWW",
      style: chartLabelStyle,
    );
    labelPainter.layout(minWidth: 0, maxWidth: size.width);
    final labelCenterRadius = radius + labelPainter.width/2;

    for (var angle = 0; angle <360; angle += 45) {
      final label = WindDirection.values[angle ~/ 45].toShortLabel();
      labelPainter.text = TextSpan(
        text: label,
        style: chartLabelStyle,
      );
      final cx = center.dx + labelCenterRadius * cos(angle * pi / 180);
      final cy = center.dy + labelCenterRadius * sin(angle * pi / 180);
      labelPainter.layout(minWidth: 0, maxWidth: size.width);
      labelPainter.paint(
        canvas,
        Offset(
          cx - labelPainter.width / 2,
          cy - labelPainter.height / 2,
        ),
      );
    }

    final path = Path();

    final List<Offset> points = [];
    for (var entry in _data.entries) {
      final angle = (entry.key.index * pi / 4) - pi / 2;
      final length = radius * (entry.value / _circleOuterRadius);

      final Offset endpoint = Offset(
        center.dx + length * cos(angle),
        center.dy + length * sin(angle),
      );

      points.add(endpoint);

      // position the number of measurements label
      final vertexLabelOffset = Offset(
        center.dx + (length + 10) * cos(angle),
        center.dy + (length + 10) * sin(angle),
      );

      // > 0.1 is a dirty hack to avoid labeling empty directions
      if (_formatVertex!= null && entry.value > 0.1) {
        final label = _formatVertex(entry.value);
        // label each vertex
        labelPainter.text = TextSpan(
          text: label,
          style: vertexLabelStyle,
        );
        labelPainter.layout(minWidth: 0, maxWidth: size.width);
        labelPainter.paint(canvas, vertexLabelOffset);

        canvas.drawLine(center, endpoint, linePaint);
      }
    }

    path.addPolygon(points, true);
    canvas.drawPath(path, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Math
final _goodIntervals = [1, 2, 5, 10, 20, 40, 50, 100, 150, 200, 250, 500, 1000];

int _nextGoodInterval(double value) {
  for (var i = 1; i < _goodIntervals.length; i++) {
    if (_goodIntervals[i] >= value) {
      return _goodIntervals[i];
    }
  }
  return _goodIntervals.last;
}

int _outerCircleRadiusIfDivision(double value, int divisions) {
  final double interval = value / divisions;
  final int closestGoodNumber = _nextGoodInterval(interval);
  return closestGoodNumber * divisions;
}

/// maximize ratio between outer circle radius and value
/// by trying different circle counts and number of circles
/// @param value usually the maximum value in the data to be displayed
/// @returns a pair with the best circle count and outer circle radius
///          corresponding to that circle count

Pair<int, int> bestCircleCountAndOuterRadius(double value) {
  int circleCount = 0;
  int circeRadius = 0;
  double ratio = -1.0;

  // there are at least 4 circles and at most 7 circles
  for (int count = 4; count <= 7; count++) {
    final outerCircleRadius = _outerCircleRadiusIfDivision(value, count);
    final currentRatio = value / outerCircleRadius;
    if (currentRatio > ratio) {
      circleCount = count;
      circeRadius = outerCircleRadius;
      ratio = currentRatio;
    }
  }

  return Pair(circleCount, circeRadius);
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:main/math/closest_rounded.dart';

import '../../ca/domain/weather_entities.dart';

const _CIRCLE_COUNT = 5;

class WindroseChartWidget extends StatelessWidget {
  final Map<WindDirection, double> _data;
  final int _maxStrength;

  WindroseChartWidget({super.key, required Map<WindDirection, double> data})
      : _data = sanitizeData(data),
        _maxStrength =
            closestRoundedNumber(data.values.reduce(max), _CIRCLE_COUNT);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(300, 300),
      painter: _WindRosePainter(_data, _maxStrength),
    );
  }

  static Map<WindDirection, double> sanitizeData(Map<WindDirection, double> data) {
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
class _WindRosePainter extends CustomPainter {
  final Map<WindDirection, double> data;
  final int _maxStrength;

  _WindRosePainter(this.data, this._maxStrength);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final Paint fillPaint = Paint()
      ..color = Colors.blue.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    const circleLabelStyle = TextStyle(color: Colors.black, fontSize: 14);

    // geometry dimensions
    final double radius = min(size.width, size.height) / 2 - 40;
    final Offset center = Offset(size.width / 2, size.height / 2);

    // Drawing circles
    for (int i = 1; i <= _CIRCLE_COUNT; i++) {
      final double currentRadius = radius * i / _CIRCLE_COUNT;

      final circlePaint = Paint()
        ..color = Colors.grey.withOpacity(0.5)
        ..style = PaintingStyle.stroke;

      canvas.drawCircle(center, currentRadius, circlePaint);

      // label each circle
      final labelCirclePainter = TextPainter(
        text: TextSpan(
          text: (_maxStrength * i / _CIRCLE_COUNT).toStringAsFixed(1),
          style: circleLabelStyle,
        ),
        textDirection: TextDirection.ltr,
      );
      labelCirclePainter.layout(minWidth: 0, maxWidth: size.width);
      labelCirclePainter.paint(
        canvas,
        Offset(center.dx - labelCirclePainter.width / 2, center.dy - currentRadius + 4),
      );
    }

    final path = Path();
    final labelPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    final List<Offset> points = [];
    for (var entry in data.entries) {
      final angle = (entry.key.index * pi / 4) - pi / 2;
      final length = radius * (entry.value / _maxStrength);

      final Offset endpoint = Offset(
        center.dx + length * cos(angle),
        center.dy + length * sin(angle),
      );

      points.add(endpoint);

      // position the compass direction label
      // TODO: NW shifted in the wrong direction
      final labelOffset = Offset(
        center.dx + (radius + 20) * cos(angle),
        center.dy + (radius + 20) * sin(angle),
      );

      // label compass directions
      labelPainter.text = TextSpan(
        text: entry.key.name,
        style: circleLabelStyle,
      );
      labelPainter.layout(minWidth: 0, maxWidth: size.width);
      labelPainter.paint(canvas, labelOffset);

      // position the strength label
      // TODO: NW shifted in the wrong direction
      final strengthLabelOffset = Offset(
        center.dx + (length + 10) * cos(angle),
        center.dy + (length + 10) * sin(angle),
      );

      if (entry.value > 0.1) {
        // label strength
        labelPainter.text = TextSpan(
          text: entry.value.toStringAsFixed(1),
          style: const TextStyle(color: Colors.red, fontSize: 12),
        );
        labelPainter.layout(minWidth: 0, maxWidth: size.width);
        labelPainter.paint(canvas, strengthLabelOffset);

        canvas.drawLine(center, endpoint, linePaint);
      }
    }

    path.addPolygon(points, true);
    canvas.drawPath(path, fillPaint);
  }


  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

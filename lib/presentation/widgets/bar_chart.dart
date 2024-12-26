import 'package:flutter/widgets.dart';

// TODO: is should not add padding to left and right side of the chart
class BarChartWidget extends StatelessWidget {
  // double presentation of data for sake of flexibility
  final List<double> _data;

  const BarChartWidget({super.key, required List<double>data}): _data = data;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
        size: const Size(double.infinity, double.infinity),
        painter: _BarChartPainter(_data),
    );
  }
}

class _BarChartPainter extends CustomPainter {
  final List<double> _data;

  _BarChartPainter(data): _data = data;

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: get from theme or props
    const barColor = Color(0xFF00C853);
    const textColor = Color(0xFF000000);
    const textStyle = TextStyle(color: textColor, fontSize: 12);

    // painters
    final barPaint = Paint()
      ..color = barColor
      ..style = PaintingStyle.fill;

    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    // loop invariants
    final maxDataValue = _data.isNotEmpty ? _data.reduce((a, b) => a > b ? a : b) : 1;
    final barWidth = size.width / _data.length;
    final rectWidth = barWidth * 0.8;
    final offset = (barWidth - rectWidth) / 2;

    // calculate label's height
    textPainter.text = const TextSpan(
      text: "96.",
      style: textStyle,
    );
    textPainter.layout(minWidth: 0, maxWidth: barWidth);
    final textHeight = textPainter.height + 1; // 1 is fix for rounding error

    // calculate scale factor
    final maxBarHeight = size.height - textHeight;
    final double scaleFactor = maxBarHeight / maxDataValue;

    // draw bars
    for (int i = 0; i < _data.length; i++) {
      final double barHeight = _data[i] * scaleFactor;
      final double x = i * barWidth + offset;
      final double y = size.height - barHeight;

      // draw a bar
      final rect = Rect.fromLTWH(
        i * barWidth+offset,               // x position
        size.height - barHeight,    // y position
        rectWidth,             // bar width (80% of allocated width)
        barHeight,                  // bar height
      );
      canvas.drawRect(rect, barPaint);

      // draw a label
      textPainter.text = TextSpan(
        text: _data[i].toStringAsFixed(1),
        style: const TextStyle(color: textColor, fontSize: 12),
      );
      textPainter.layout(minWidth: 0, maxWidth: barWidth);

      final textX = x + rectWidth / 2 - textPainter.width / 2;
      final textY = y - textPainter.height - 4;
      textPainter.layout(minWidth: 0, maxWidth: barWidth);
      textPainter.paint(canvas, Offset(textX, textY));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
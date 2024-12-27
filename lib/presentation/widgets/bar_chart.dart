import 'package:flutter/widgets.dart';

const int _V_PADDING = 4;

// TODO: is should not add padding to left and right side of the chart
class BarChartWidget extends StatelessWidget {
  // double presentation of data for sake of flexibility
  final List<double> _data;
  final List<String> _labels;

  const BarChartWidget(
      {super.key, required List<double> data, List<String> labels = const []})
      : _data = data,
        _labels = labels;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, double.infinity),
      painter: _BarChartPainter(_data, _labels),
    );
  }
}

class _BarChartPainter extends CustomPainter {
  final List<double> _data;
  final List<String> _labels;

  _BarChartPainter(data, labels) : _data = data, _labels = labels;

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
    final maxDataValue =
        _data.isNotEmpty ? _data.reduce((a, b) => a > b ? a : b) : 1;
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
    final maxBarHeight = size.height - textHeight - textHeight - _V_PADDING - _V_PADDING;
    final double scaleFactor = maxBarHeight / maxDataValue;

    // draw bars
    for (int i = 0; i < _data.length; i++) {
      final double barHeight = _data[i] * scaleFactor;
      final double x = i * barWidth + offset;
      final double y = size.height - barHeight;

      // draw a bar
      final rect = Rect.fromLTWH(
        i * barWidth + offset, // x position
        size.height - barHeight - _V_PADDING, // y position
        rectWidth, // bar width (80% of allocated width)
        barHeight, // bar height
      );
      canvas.drawRect(rect, barPaint);

      // draw a top label
      textPainter.text = TextSpan(
        text: _data[i].toStringAsFixed(1),
        // TODO: hardcoded style
        style: const TextStyle(color: textColor, fontSize: 12),
      );
      textPainter.layout(minWidth: 0, maxWidth: barWidth);

      final textX = x + rectWidth / 2 - textPainter.width / 2;
      final textY = y - textPainter.height - 4;
      textPainter.layout(minWidth: 0, maxWidth: barWidth);
      textPainter.paint(canvas, Offset(textX, textY));

      // draw a bottom label
      if (i < _labels.length) {
        textPainter.text = TextSpan(
          text: _labels[i],
          // TODO: hardcoded style
          style: const TextStyle(color: textColor, fontSize: 12),
        );
        textPainter.layout(minWidth: 0, maxWidth: barWidth);

        final textX = x + rectWidth / 2 - textPainter.width / 2;
        final textY = size.height - textHeight;
        textPainter.layout(minWidth: 0, maxWidth: barWidth);
        textPainter.paint(canvas, Offset(textX, size.height - _V_PADDING));
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

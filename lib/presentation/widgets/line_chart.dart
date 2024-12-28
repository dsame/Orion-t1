import 'dart:math';

import 'package:flutter/widgets.dart';

const _V_SPACE = 4;

class LineChartWidget extends StatelessWidget {
  final List<double> line1Data;
  final List<double> line2Data;
  final List<String> labels;
  final String Function(double)? formatValue;

  const LineChartWidget(
      {super.key,
      required this.line1Data,
      required this.line2Data,
      this.labels = const [],
      this.formatValue});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, double.infinity),
      // Width: match parent, Height: 300
      painter: _LineChartPainter(line1Data, line2Data, labels, formatValue),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> line1Data;
  final List<double> line2Data;
  final List<String> labels;
  final String Function(double)? formatValue;

  _LineChartPainter(
      this.line1Data, this.line2Data, this.labels, this.formatValue);

  @override
  void paint(Canvas canvas, Size size) {
    Color color1 = const Color(0xFF00C853);
    Color color2 = const Color(0xFF0053C8);
    Color colorGrid = const Color(0xFF000000).withOpacity(0.1);
    Color colorXLabel = const Color(0xFF000000);
    Color colorYLabel = const Color(0xFFFF0000).withOpacity(0.5);

    final paintLine1 = Paint()
      ..color = color1
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final paintLine2 = Paint()
      ..color = color2
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final paintGrid = Paint()
      ..color = colorGrid
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final labelXPainter = TextPainter()..textDirection = TextDirection.ltr;
    final labelXStyle = TextStyle(color: colorXLabel, fontSize: 10);
    labelXPainter.text = TextSpan(
      text: '96.',
      style: labelXStyle,
    );
    labelXPainter.layout();
    final labelXHeight = labelXPainter.height;

    final labelYPainter = TextPainter()..textDirection = TextDirection.ltr;
    final labelYStyle = TextStyle(color: colorYLabel, fontSize: 10);
    labelYPainter.text = TextSpan(
      text: '96.',
      style: labelYStyle,
    );
    labelYPainter.layout();
    final labelYHeight = labelYPainter.height;

    final count =
        [line1Data.length, line2Data.length, labels.length].reduce(max);
    final stripeWidth = size.width / count;
    final stripeTop = labelXHeight + _V_SPACE;
    final stripeBottom = size.height - labelXHeight - _V_SPACE;
    final stripeHeight = stripeBottom - stripeTop;
    final minValue = [line1Data, line2Data].expand((e) => e).reduce(min);
    final maxValue = [line1Data, line2Data].expand((e) => e).reduce(max);
    final scale = (maxValue - minValue) / stripeHeight;

    for (int i = 0; i < count; i++) {
      // labels
      if (labels.length > i) {
        labelXPainter.text = TextSpan(
          text: labels[i],
          style: labelXStyle,
        );
        labelXPainter.layout();
        // bottom
        labelXPainter.paint(
            canvas,
            Offset(i * stripeWidth + stripeWidth / 2 - labelXPainter.width / 2,
                size.height - labelXHeight));
        // top
        labelXPainter.paint(
            canvas,
            Offset(i * stripeWidth + stripeWidth / 2 - labelXPainter.width / 2,
                0));
      }
      final h_center = i * stripeWidth + stripeWidth / 2;
      // vertical grid line
      canvas.drawLine(Offset(h_center, stripeTop),
          Offset(h_center, stripeBottom), paintGrid);

      // value 1
      if (line1Data.length > i + 1) {
        final x1 = h_center;
        final y1 = stripeBottom - (line1Data[i] - minValue) / scale;
        final x2 = h_center + stripeWidth;
        final y2 = stripeBottom - (line1Data[i + 1] - minValue) / scale;
        canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paintLine1);
      }
      // value 2
      if (line2Data.length > i + 1) {
        final x1 = h_center;
        final y1 = stripeBottom - (line2Data[i] - minValue) / scale;
        final x2 = h_center + stripeWidth;
        final y2 = stripeBottom - (line2Data[i + 1] - minValue) / scale;
        canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paintLine2);
      }
      // value 1 label
      if (formatValue != null && line1Data.length > i) {
        labelYPainter.text = TextSpan(
          text: formatValue!(line1Data[i]),
          style: labelYStyle,
        );
        labelYPainter.layout();
        double y = stripeBottom - (line1Data[i] - minValue) / scale;
        if (i < line1Data.length - 1 && line1Data[i] > line1Data[i + 1]) {
          y -= labelYHeight;
        }
        if (y > stripeBottom - labelYHeight) {
          y = stripeBottom - labelYHeight;
        }
        labelYPainter.paint(canvas, Offset(h_center + 1, y));
      }
      // value 2 label
      if (formatValue != null && line2Data.length > i) {
        labelYPainter.text = TextSpan(
          text: formatValue!(line2Data[i]),
          style: labelYStyle,
        );
        labelYPainter.layout();
        double y = stripeBottom - (line2Data[i] - minValue) / scale;
        if (i < line2Data.length - 1 && line2Data[i] > line2Data[i + 1]) {
          y -= labelYHeight;
        }
        if (y < stripeTop) {
          y = stripeTop;
        }
        labelYPainter.paint(canvas, Offset(h_center + 1, y));
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

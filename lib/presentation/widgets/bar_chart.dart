import 'package:flutter/widgets.dart';

// vertical space between bars and labels
const int _V_SPACE = 4;

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

  _BarChartPainter(data, labels)
      : _data = data,
        _labels = labels;

  @override
  void paint(Canvas canvas, Size size) {
    // colors
    // TODO: get from theme or props
    const barColor = Color(0xFF00C853);
    const textColor = Color(0xFF000000);

    // known dimensions
    final barWidth = size.width / (_data.length + 0.3 * (_data.length - 1));
    final barOffset = barWidth * 0.3;
    final maxDataValue =
        _data.isNotEmpty ? _data.reduce((a, b) => a > b ? a : b) : 1;

    // painters
    final barPaint = Paint()
      ..color = barColor
      ..style = PaintingStyle.fill;

    final textTopLabelPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    final textBottomLabelPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    // text styles
    const topLabelStyle = TextStyle(color: textColor, fontSize: 12);
    const bottomLabelStyle = TextStyle(color: textColor, fontSize: 12);

    textTopLabelPainter.text = const TextSpan(
      text: "96.",
      style: topLabelStyle,
    );

    textBottomLabelPainter.text = const TextSpan(
      text: "96.",
      style: bottomLabelStyle,
    );

    // calculate label's height
    textTopLabelPainter.layout(minWidth: 0, maxWidth: barWidth);
    final textTopHeight =
        textTopLabelPainter.height; // 1 is fix for rounding error

    textBottomLabelPainter.layout(minWidth: 0, maxWidth: barWidth);
    final textBottomHeight =
        textBottomLabelPainter.height; // 1 is fix for rounding error

    // calculate scale factor
    final maxBarHeight =
        size.height - textTopHeight - textBottomHeight - _V_SPACE - _V_SPACE;
    final double scaleFactor = maxBarHeight / maxDataValue;

    // draw bars
    for (int i = 0; i < _data.length; i++) {
      // per bar dimensions
      final double barHeight = _data[i] * scaleFactor;
      final double barLeft = i * barWidth + i * barOffset;
      final double barTop = size.height - textTopHeight - barHeight;

      // draw a bar
      final rect = Rect.fromLTWH(
        barLeft, // x position
        barTop, // y position
        barWidth, // bar width (80% of allocated width)
        barHeight, // bar height
      );
      canvas.drawRect(rect, barPaint);

      // draw a top label
      textTopLabelPainter.text = TextSpan(
        text: _data[i].toStringAsFixed(1),
        style: topLabelStyle,
      );
      textTopLabelPainter.layout(minWidth: 0, maxWidth: barWidth);

      final textTopX = barLeft + barWidth / 2 - textTopLabelPainter.width / 2;
      final textTopY = barTop - textTopLabelPainter.height - 4;
      textTopLabelPainter.layout(minWidth: 0, maxWidth: barWidth);
      textTopLabelPainter.paint(canvas, Offset(textTopX, textTopY));

      // draw a bottom label
      if (i < _labels.length) {
        textBottomLabelPainter.text = TextSpan(
          text: _labels[i],
          style: bottomLabelStyle,
        );
        textBottomLabelPainter.layout(minWidth: 0, maxWidth: barWidth);

        final textBottomX =
            barLeft + barWidth / 2 - textBottomLabelPainter.width / 2;
        final textBottomY = size.height - textBottomLabelPainter.height;
        textBottomLabelPainter.paint(canvas, Offset(textBottomX, textBottomY));
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

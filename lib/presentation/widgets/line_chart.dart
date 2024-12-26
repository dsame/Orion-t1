import 'package:flutter/widgets.dart';

class LineChartWidget extends StatelessWidget {
  final List<double> line1Data;
  final List<double> line2Data;

  const LineChartWidget({super.key, required this.line1Data, required this.line2Data});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, double.infinity), // Width: match parent, Height: 300
      painter: _LineChartPainter(line1Data, line2Data),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> line1Data;
  final List<double> line2Data;

  _LineChartPainter(this.line1Data, this.line2Data);

  @override
  void paint(Canvas canvas, Size size) {
    Color color1 = const Color(0xFF00C853);
    Color color2 = const Color(0xFF00C853);
    Color colorGrid = const Color(0xFF00C853).withOpacity(0.3);

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

    const double margin = 20.0;

    // Draw grid lines
    for (double i = margin; i < size.height; i += 40) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paintGrid);
    }

    for (double i = margin; i < size.width; i += 40) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paintGrid);
    }

    // Transform data points to fit within the chart
    final normalizedLine1 = normalizeData(line1Data, size.width, size.height, margin);
    final normalizedLine2 = normalizeData(line2Data, size.width, size.height, margin);

    // Draw the first line
    for (int i = 0; i < normalizedLine1.length - 1; i++) {
      canvas.drawLine(normalizedLine1[i], normalizedLine1[i + 1], paintLine1);
    }

    // Draw the second line
    for (int i = 0; i < normalizedLine2.length - 1; i++) {
      canvas.drawLine(normalizedLine2[i], normalizedLine2[i + 1], paintLine2);
    }
  }

  List<Offset> normalizeData(List<double> data, double width, double height, double margin) {
    final double xStep = (width - 2 * margin) / (data.length - 1);
    final double maxY = data.reduce((a, b) => a > b ? a : b);
    final double minY = data.reduce((a, b) => a < b ? a : b);

    return List.generate(data.length, (i) {
      final x = margin + i * xStep;
      final y = margin + ((data[i] - minY) / (maxY - minY)) * (height - 2 * margin);
      return Offset(x, height - y); // Flip y-axis for proper chart orientation
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
import 'dart:math';
import 'package:flutter/material.dart';

class Compass extends StatelessWidget {
  final double angle; // Angle in degrees to draw on the compass

  const Compass({super.key, required this.angle});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(150, 150),
      painter: CompassPainter(angle: angle),
    );
  }
}

class CompassPainter extends CustomPainter {
  final double angle;
  final Paint circlePaint = Paint()
    ..color = Colors.grey.shade300
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3;
  final Paint linePaint = Paint()
    ..color = Colors.red
    ..strokeWidth = 2;
  final Paint pointPaint = Paint()
    ..color = Colors.red
    ..style = PaintingStyle.fill;

  CompassPainter({required this.angle});

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);

    // Draw the static elements (compass circle and cardinal directions)
    canvas.drawCircle(center, radius, circlePaint);
    _drawCardinalDirections(canvas, center, radius);

    // Draw the dynamic angle indicator
    final double angleRad = angle * pi / 180;
    final Offset pointOffset = Offset(
      center.dx + radius * 0.75 * cos(angleRad),
      center.dy + radius * 0.75 * sin(angleRad),
    );

    canvas.drawCircle(pointOffset, 8, pointPaint);
    canvas.drawLine(center, pointOffset, linePaint);
  }

  // Method to draw the cardinal directions
  void _drawCardinalDirections(Canvas canvas, Offset center, double radius) {
    final Map<String, double> cardinalDirections = {
      'N': 0,
      'E': 90,
      'S': 180,
      'W': 270,
    };

    final TextPainter textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    for (var entry in cardinalDirections.entries) {
      final double angleRad = entry.value * pi / 180;
      final Offset offset = Offset(
        center.dx + radius * 0.85 * cos(angleRad) - 10,
        center.dy + radius * 0.85 * sin(angleRad) - 10,
      );

      textPainter.text = TextSpan(
        text: entry.key,
        style: TextStyle(color: Colors.black, fontSize: 14),
      );
      textPainter.layout();
      textPainter.paint(canvas, offset);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    final oldPainter = oldDelegate as CompassPainter;
    // Only repaint if the angle changes
    return oldPainter.angle != angle;
  }
}

import 'dart:math';
import 'package:flutter/material.dart';
class SectorPainter extends CustomPainter {
  final Color color;
  final double radius;
  final double angle;

  SectorPainter({
    required this.color,
    required this.radius,
    required this.angle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke;

    Offset circleCenter = Offset(size.width / 2, size.height / 2);
    Rect rectangle = Rect.fromCircle(center: circleCenter, radius: radius);

    bool useCenter = true;

    canvas.drawArc(rectangle, -angle / 2 - pi / 2, angle, useCenter, Paint()
      ..color = color
      ..style = PaintingStyle.fill);
    canvas.drawArc(rectangle, -angle / 2 - pi / 2, angle, useCenter, paint);
  }

  @override
  bool shouldRepaint(covariant SectorPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.radius != radius ||
      oldDelegate.angle != angle;
}



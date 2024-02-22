import 'dart:math' as math;

import 'package:flutter/rendering.dart';

class SegmentPainter extends CustomPainter {
  final Color color;
  final double angle;
  final double radius;

  const SegmentPainter({
    required this.color,
    required this.angle,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final x = math.sin(angle / 2) * radius;
    final y = math.cos(angle / 2) * radius;

    final paint = Paint()..color = color;
    final strokeWidth = 3.0;
    final path = Path()
      ..moveTo(x, 0)
      ..lineTo(0, y)
      ..arcTo(
        Rect.fromCircle(
          center: Offset(x, -y),
          radius: radius,
        ),
        -math.pi / 2 -angle / 2,
        -angle,
        false,
      )
      // ..arcTo(rect, startAngle, sweepAngle, forceMoveTo)
      // ..arcToPoint(
      //   Offset(2 * x, 0),
      //   radius: Radius.circular(radius),
      //   rotation: angle * math.pi,
      //   clockwise: false,
      //   largeArc: true,
      // )
      // ..lineTo(x, x)
      ..close();
    // final path = Path()
    //   ..moveTo(strokeWidth, strokeWidth)
    //   ..arcToPoint(Offset(size.width - strokeWidth, size.height - strokeWidth),
    //       radius: Radius.circular(math.max(size.width, size.height)));

    canvas.drawPath(path, paint);

    // canvas.drawRect(
    //   rect,
    //   Paint()..color = color,
    // );
  }

  @override
  bool shouldRepaint(SegmentPainter oldDelegate) => color != oldDelegate.color;
}

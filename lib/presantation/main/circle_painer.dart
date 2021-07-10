import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CirclePainter extends CustomPainter {
  final double percentage;
  final double circleRadius;

  CirclePainter({required this.percentage, required this.circleRadius});

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 1; i < (360 * percentage); i += 5) {
      final per = i / 360.0;
      final color = ColorTween(
        begin: Colors.blue.shade200,
        end: Colors.blue.shade200,
      ).lerp(per);
      final paint = Paint()
        ..color = color!
        ..style = PaintingStyle.stroke
        ..strokeWidth = 30;

      final spaceLen = 0;
      final lineLen = 30;
      final angle = (2 * pi * per) - (pi / 2);
      // final angle = (2 * pi * per);

      // 円の中心座標
      final offset0 = Offset(size.width * 0.5, size.height * 0.5);

      // 線の内側部分の座標
      final offset1 = offset0.translate(
        (circleRadius + spaceLen) * cos(angle),
        (circleRadius + spaceLen) * sin(angle),
      );

      // 線の外側部分の座標
      final offset2 = offset1.translate(
        lineLen * cos(angle),
        lineLen * sin(angle),
      );

      canvas.drawLine(offset1, offset2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}

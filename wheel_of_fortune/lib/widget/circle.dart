import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dz/widget/sector_painter.dart';

class Circle extends StatelessWidget {
  final List<String> names;

  const Circle({super.key, required this.names});

  @override
  Widget build(BuildContext context) {
    List<Widget> circle = [];
    for (int i = 1; i <= names.length; i++) {
      circle.add(Transform.rotate(
          angle: 2 * pi / names.length * (i-1),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              CustomPaint(
                painter: SectorPainter(
                  color: names.length % 2 == 1
                      ? (i % 3 == 0
                          ? (Colors.white)
                          : (i % 3 == 1 ? (Colors.cyanAccent) : (Colors.red)))
                      : (i % 2 == 1 ? Colors.cyanAccent : Colors.red),
                  angle: 2 * pi / names.length,
                  radius: 140,
                ),
              ),
              Transform.rotate(
                angle: pi / 2,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(names[i - 1]),
                    const SizedBox(
                      width: 100,
                    )
                  ],
                ),
              )
            ],
          )));
    }
    return SizedBox(
      width: 300,
      height: 300,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: circle,
      ),
    );
  }
}

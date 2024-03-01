import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dz/widget/sector_painter.dart';

class Circle extends StatelessWidget {
  final List<String> names;
  final double size;

  const Circle({super.key, required this.names, required this.size});

  @override
  Widget build(BuildContext context) {
    List<Widget> circle = [];
    for (int i = 1; i <= names.length; i++) {
      circle.add(
        Transform.rotate(
          angle: 2 * pi / names.length * (i - 1),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              CustomPaint(
                painter: SectorPainter(
                  color: Colors.cyan,
                  /*names.length % 2 == 1
                      ? (i % 3 == 0
                          ? (Colors.white)
                          : (i % 3 == 1 ? (Colors.cyanAccent) : (Colors.red)))
                      : (i % 2 == 1 ? Colors.cyanAccent : Colors.red),*/
                  angle: 2 * pi / names.length,
                  radius: size / 2,
                ),
              ),
              Transform.rotate(
                angle: pi / 2,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Spacer(),
                    SizedBox(
                        width: size / 5,
                        child: Text(
                          names[i - 1],
                          style: TextStyle(
                            fontSize: size / 30,
                            fontWeight: FontWeight.w600,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                        )),
                    const Spacer(
                      flex: 6,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: circle,
      ),
    );
  }
}

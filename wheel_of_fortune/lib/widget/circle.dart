import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dz/widget/sector_painter.dart';

class Circle extends StatelessWidget {
  final List<String> names;
  final double size;
  final Set<int> setindex;

  const Circle(
      {super.key,
      required this.names,
      required this.size,
      required this.setindex});

  @override
  Widget build(BuildContext context) {
    final circle = [
      for (int i = 0; i < names.length; i++)
        Transform.rotate(
          angle: 2 * pi / names.length * (i),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              CustomPaint(
                painter: SectorPainter(
                  color: (setindex.contains(i)) ? Colors.blueGrey : Colors.cyan,
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
                          names[i],
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
    ];

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

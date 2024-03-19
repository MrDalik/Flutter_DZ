import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dz/widget/circle.dart';
import 'package:flutter_dz/widget/sector_painter.dart';

const _minCircleDiameter = 200.0;
const _maxCircleDiameter = 600.0;

class RandomItemPage extends StatefulWidget {
  final List<String> namesInput;

  const RandomItemPage({super.key, required this.namesInput});

  @override
  State<RandomItemPage> createState() => _RandomItemPageState();
}

class _RandomItemPageState extends State<RandomItemPage>
    with SingleTickerProviderStateMixin {
  int? randomIndex;
  Set<int> setNumbersDrawn = {};

  List<String> names = [];
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  );
  double turns = 0;
  double lastRotationValue = 0;
  int _currentIndex = 0;
  int _previousIndex = 0;
  double sizeTransformList = _maxCircleDiameter;

  @override
  void initState() {
    super.initState();
    names.addAll(widget.namesInput);

    // нужно, чтобы вызвать setState
    _animationController.addListener(_onAnimationUpdate);
    // нужно, чтобы узнать об окончании анимации
    _animationController.addStatusListener(_onAnimationStatusUpdate);
  }

  @override
  void dispose() {
    _animationController.removeListener(_onAnimationUpdate);
    _animationController.removeStatusListener(_onAnimationStatusUpdate);
    _animationController.dispose();
    super.dispose();
  }

  void _addItem(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => DialogItem(
              text: '',
              onPressed: (String text) {
                setState(() {
                  names.add(text);
                  _calculateDiffAngle(names.length - 1, names.length);
                });
              },
            ));
  }

  void _calculateDiffAngle(int oldSegmentCount, int newSegmentCount) {
    final oldAngle = 2 * pi / oldSegmentCount;
    final newAngle = 2 * pi / newSegmentCount;
    final deltaAngle = oldAngle - newAngle;
    lastRotationValue += deltaAngle * _previousIndex;
    turns = -newAngle * (_currentIndex - _previousIndex);
  }

  void _delItem(int index) {
    Set<int> localSet = {};
    setState(() {
      names.removeAt(index);
      setNumbersDrawn.remove(index);
      for (final setIndex in setNumbersDrawn) {
        if (setIndex > index) {
          localSet.add(setIndex - 1);
        } else {
          localSet.add(setIndex);
        }
      }
      setNumbersDrawn = localSet;
      debugPrint('set $setNumbersDrawn arr $names');
      _calculateDiffAngle(names.length + 1, names.length);
    });
  }

  void _random() {
    final index = _getNextIndex();
    lastRotationValue += turns;
    turns = 2 * pi / names.length * (_currentIndex - index) + pi * 4;
    _previousIndex = _currentIndex;
    _currentIndex = index;
    _animationController
      ..reset()
      ..forward();
  }

  int _getNextIndex() {
    final unusedIndices = List.generate(names.length, (index) => index)
        .toSet()
        .difference(setNumbersDrawn);
    return unusedIndices.elementAt(Random().nextInt(unusedIndices.length));
  }

  void _changeItem(text, index) {
    showDialog(
        context: context,
        builder: (context) => DialogItem(
              text: names[index],
              onPressed: (String text) {
                setState(() {
                  names[index] = text;
                });
              },
            ));
  }

  void _restart() {
    setState(() {
      setNumbersDrawn.clear();
      turns = 0;
      lastRotationValue = 0;
      _currentIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: sizeTransformList,
            padding: const EdgeInsets.all(20),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final circleDiameter =
                    min(constraints.maxHeight, constraints.maxWidth);
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.rotate(
                      angle: lastRotationValue +
                          _animationController.value * turns,
                      child: Circle(
                        names: names,
                        size: circleDiameter,
                        setindex: setNumbersDrawn,
                      ),
                    ),
                    CustomPaint(
                      painter: SectorPainter(
                        color: Colors.black,
                        radius: circleDiameter / 50,
                        angle: 2 * pi,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Transform.rotate(
                          angle: pi,
                          child: CustomPaint(
                            painter: SectorPainter(
                              color: Colors.black,
                              radius: circleDiameter / 33,
                              angle: pi / 2,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: circleDiameter / 10,
                        ),
                      ],
                    )
                  ],
                );
              },
            ),
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    sizeTransformList = (sizeTransformList + details.delta.dy)
                        .clamp(_minCircleDiameter, _maxCircleDiameter);
                  });
                },
                child: Container(
                  height: 10,
                  color: Colors.black,
                )),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                onPressed: _random,
                child: const Icon(Icons.play_arrow),
              ),
              const SizedBox(width: 10),
              FloatingActionButton(
                onPressed: () => _addItem(context),
                child: const Icon(Icons.add),
              ),
              const SizedBox(width: 10),
              FloatingActionButton(
                onPressed: _restart,
                child: const Icon(Icons.refresh),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Flexible(
            child: ListView.builder(
              itemCount: names.length,
              itemBuilder: (BuildContext context, int index) {
                final isDrawn = setNumbersDrawn.contains(index);
                return GestureDetector(
                  onTap: () => _changeItem(names[index], index),
                  child: Container(
                    color: isDrawn
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.primaryContainer,
                    child: ListTile(
                      title: Text(
                        names[index],
                        style: TextStyle(
                          color: isDrawn ? Colors.white : Colors.black,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                              onPressed: () => setState(
                                    () {
                                      if (setNumbersDrawn.contains(index)) {
                                        setNumbersDrawn.remove(index);
                                      } else {
                                        setNumbersDrawn.add(index);
                                      }
                                    },
                                  ),
                              child: const Icon(Icons.add_box_outlined)),
                          CloseButton(
                            onPressed: names.length == 1
                                ? null
                                : () => _delItem(index),
                          ),
                        ],
                      ),
                      selectedColor: Colors.black,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onAnimationUpdate() {
    setState(() {});
  }

  void _onAnimationStatusUpdate(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      setState(() {
        setNumbersDrawn.add(_currentIndex);
      });
    }
  }
}

class DialogItem extends StatefulWidget {
  final void Function(String text) onPressed;
  final String text;

  const DialogItem({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  State<DialogItem> createState() => _DialogItemState();
}

class _DialogItemState extends State<DialogItem> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.text);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 200,
      child: Dialog(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: _controller),
                const SizedBox(
                  height: 8,
                ),
                ElevatedButton(
                  onPressed: () {
                    widget.onPressed(_controller.text);
                    Navigator.pop(context);
                  },
                  child: const Text('add'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

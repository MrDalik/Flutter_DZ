import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dz/widget/circle.dart';
import 'package:flutter_dz/widget/sector_painter.dart';

class RandomItemPage extends StatefulWidget {
  final List<String> names_input;

  const RandomItemPage({super.key, required this.names_input});

  @override
  State<RandomItemPage> createState() => _RandomItemPageState();
}

class _RandomItemPageState extends State<RandomItemPage>
    with SingleTickerProviderStateMixin {
  final setnumbersdrawn = <int>{};
  final names = <String>[];

  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  );

  Animation? _animation;

  int _lastIndex = 0;
  double _lastRotationValue = 0;
  int? _nextIndex;

  @override
  void initState() {
    super.initState();
    names.addAll(widget.names_input);

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

  void _onAnimationUpdate() {
    setState(() {});
  }

  void _onAnimationStatusUpdate(AnimationStatus status) {
    if (status == AnimationStatus.completed && _nextIndex != null) {
      setState(() {
        setnumbersdrawn.add(_nextIndex!);
      });
    }
  }

  void _addItem(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => DialogItem(
              text: '',
              onPressed: (String text) {
                setState(() {
                  names.add(text);
                });
              },
            ));
  }

  void _delItem(int index) {
    setState(() {
      names.removeAt(index);
    });
  }

  void _random() {
    final nextIndex = _getNextIndex();
    debugPrint('nextIndex: $nextIndex');
    _nextIndex = nextIndex;

    final turns = _lastRotationValue +
        (2 * pi / names.length) * (_lastIndex - nextIndex) +
        pi * 10;

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ).drive(
      Tween<double>(
        begin: _lastRotationValue,
        end: turns,
      ),
    );
    _lastIndex = nextIndex;
    _lastRotationValue = turns;
    // нужно, чтобы запустить анимацию
    _animationController
      ..reset()
      ..forward();
  }

  int _getNextIndex() {
    final unusedIndices = List.generate(names.length, (index) => index)
        .toSet()
        .difference(setnumbersdrawn);
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
      setnumbersdrawn.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Transform.rotate(
              angle: _animation?.value ?? 0,
              child: Circle(
                names: names,
                size: 500,
              ),
            ),
            CustomPaint(
                painter: SectorPainter(
                    color: Colors.black, radius: 10, angle: 2 * pi)),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.rotate(
                  angle: pi,
                  child: CustomPaint(
                      painter: SectorPainter(
                          color: Colors.black, radius: 15, angle: pi / 2)),
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            )
          ],
        ),
        Expanded(
          child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                    onTap: () => _changeItem(names[index], index),
                    child: Container(
                      color: setnumbersdrawn.contains(index)
                          ? Colors.blueGrey
                          : Colors.green,
                      child: ListTile(
                        title: Text(
                          names[index],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                                onPressed: () => setState(() {
                                      if (setnumbersdrawn.contains(index)) {
                                        setnumbersdrawn.remove(index);
                                      } else {
                                        setnumbersdrawn.add(index);
                                      }
                                    }),
                                child: const Icon(Icons.add_box_outlined)),
                            CloseButton(
                              onPressed: () => _delItem(index),
                            ),
                          ],
                        ),
                        selectedColor: Colors.black,
                      ),
                    ));
              },
              itemCount: names.length),
        ),
        Row(
          children: [
            FloatingActionButton(
              onPressed: () => _addItem(context),
              child: const Icon(Icons.add),
            ),
            FloatingActionButton(
              onPressed: _random,
              child: const Text('R'),
            ),
            FloatingActionButton(
              onPressed: _restart,
              child: const Icon(Icons.refresh),
            ),
          ],
        ),
      ]),
    );
  }
}

class DialogItem extends StatelessWidget {
  final void Function(String text) onPressed;
  String text;

  DialogItem({super.key, required this.onPressed, required this.text});

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
                TextField(
                  controller: TextEditingController(text: text),
                  onChanged: (value) => text = value,
                ),
                const SizedBox(
                  height: 8,
                ),
                ElevatedButton(
                  onPressed: () {
                    onPressed(text);
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

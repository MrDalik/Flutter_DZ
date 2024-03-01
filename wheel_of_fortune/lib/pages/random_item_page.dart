import 'dart:async';
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

class _RandomItemPageState extends State<RandomItemPage> {
  int? randomindex;
  Set<int> setnumbersdrawn = {};

  List<String> names = [];
  static const c1 = Color(0xFFFFFF00);
  static const c2 = Color(0xFFD000FF);
  var color = c1;
  double turns = 0;
  int early_random = 0;
  bool seconds_flag = false;

  @override
  void initState() {
    super.initState();
    names.addAll(widget.names_input);
    // todo delete timer
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        color = color == c1 ? c2 : c1;
      });
    });
  }

  void _addItem(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => DialogItem(
              text: '',
              onPressed: (String text) {
                setState(() {
                  turns = 0;
                  early_random = 0;
                  names.add(text);
                });
              },
            ));
  }

  void _delItem(int index) {
    setState(() {
      names.removeAt(index);
      turns = 0;
      early_random = 0;
    });
  }

  void _random() {
    setState(() {
      seconds_flag = false;
      int interrand = Random().nextInt(names.length);
      if (!setnumbersdrawn.contains(interrand)) {
        randomindex = interrand;
        setnumbersdrawn.add(randomindex!);
        turns += -((1 / names.length) * (randomindex! - early_random) +
            Random().nextInt(3) +
            1);
        early_random = randomindex!;
      } else {
        _random();
      }
    });
  }

  void _changeItem(text, index) {
    seconds_flag = false;
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
      seconds_flag = true;
      turns = 0;
      early_random = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Stack(
          alignment: Alignment.center,
          children: [
            AnimatedRotation(
              turns: turns,
              curve: Curves.easeInOutCirc,
              duration: Duration(seconds: seconds_flag ? 0 : 7),
              child: Circle(
                names: names, size: 500,
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
                      color: setnumbersdrawn.contains(index)?
                              Colors.blueGrey : Colors.green,
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


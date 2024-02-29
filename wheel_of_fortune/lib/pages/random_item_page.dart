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
  double turns=0;
  int early_random=0;

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
        builder: (context) =>
            DialogItem(
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
    setState(() {
      int interrand = Random().nextInt(names.length);
      if (!setnumbersdrawn.contains(interrand)) {
        randomindex = interrand;
        setnumbersdrawn.add(randomindex!);
        turns += -((1/names.length)*(randomindex!-early_random));
        early_random=randomindex!;
      } else {
        _random();
      }
    });
  }

  void _changeItem(text, index) {
    showDialog(
        context: context,
        builder: (context) =>
            DialogItem(
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
      turns=0;
      early_random=0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
          AnimatedRotation(
          turns: turns,
          duration: const Duration(seconds: 1),
          child: Circle(names: names,),),
        Expanded(
          child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                    onTap: () => _changeItem(names[index], index),
                    child: Container(
                      color: setnumbersdrawn.contains(index)
                          ? randomindex == index
                          ? Colors.red
                          : Colors.blueGrey
                          : Colors.green,
                      child: ListTile(
                        title: Text(
                          names[index],
                        ),
                        trailing: CloseButton(
                          onPressed: () => _delItem(index),
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

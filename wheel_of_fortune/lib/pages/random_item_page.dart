import 'dart:math';

import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    names.addAll(widget.names_input);
  }

  void _addItem(BuildContext context) {
    var text = '';

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          children: [
            TextField(
              onChanged: (value) => text = value,
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  names.add(text);
                });
                Navigator.pop(context);
              },
              child: const Text('save'),
            ),
          ],
        ),
      ),
    );
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
      } else {
        _random();
      }
    });
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
        Expanded(
          child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Container(
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
                );
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

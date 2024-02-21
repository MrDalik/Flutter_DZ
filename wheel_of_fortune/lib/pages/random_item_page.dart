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

  void _changeItem(text, index) {
    showDialog(
        context: context,
        builder: (context) => DialogItem(
          text:  names[index],
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
        Expanded(
          child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                    onTap: () => _changeItem(names[index],index),
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
    return Dialog(
        child: Container(
      color: Colors.blue,
      child: Center(
        child: Column(
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
    ));
  }
}

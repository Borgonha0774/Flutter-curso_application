import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/item.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  var items = <Item>[];

  HomePage() {
    items = [];
    /* items.add(Item(title: 'Maça', done: false));
    items.add(Item(title: 'Banana', done: true));
    items.add(Item(title: 'Laranja', done: false)); */
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var newTaskController = TextEditingController();

  void add() {
    if (newTaskController.text.isEmpty) return;
    setState(() {
      widget.items.add(Item(title: newTaskController.text, done: false));
      //newTaskController.text = ''; // ou abaico
      newTaskController.clear();
      save();
    });
  }

  void remove(int index) {
    setState(() {
      widget.items.removeAt((index));
      save();
    });
  }

  Future load() async {
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('data');

    if (data != null) {
      Iterable decoded = jsonDecode(data);
      List<Item> result = decoded.map((e) => Item.fromJson(e)).toList();
      setState(() {
        widget.items = result;
      });
    }
  }

  save() async {
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.setString('data', jsonEncode(widget.items));
  }

  _HomePageState() {
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller: newTaskController,
          keyboardType: TextInputType.text,
          style: const TextStyle(color: Colors.white, fontSize: 18),
          decoration: const InputDecoration(
            labelText: 'Nova Tarefa',
            labelStyle: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: widget.items.length,
        itemBuilder: (BuildContext ctxt, int index) {
          final item = widget.items[index];
          return Dismissible(
            key: Key(item.title.toString()),
            background: Container(
              color: Color.fromARGB(255, 189, 94, 88).withOpacity(0.2),
            ),
            onDismissed: (direction) {
              remove(index);
            },
            child: CheckboxListTile(
              title: Text(item.title.toString()),
              value: item.done,
              onChanged: (bool? value) {
                setState(() {
                  item.done = value;
                  save();
                });
              },
            ),
          );
          /* return  */
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          return add();
        },
        backgroundColor: Colors.pink,
        child: Icon(Icons.add),
      ),
    );
  }
}

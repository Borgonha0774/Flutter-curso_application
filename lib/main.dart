import 'package:flutter/material.dart';
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
    items.add(Item(title: 'Maça', done: false));
    items.add(Item(title: 'Banana', done: true));
    items.add(Item(title: 'Laranja', done: false));
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: ListView.builder(
        itemCount: widget.items.length,
        itemBuilder: (BuildContext ctxt, int index) {
          final item = widget.items[index];

          return CheckboxListTile(
            title: Text(item.title.toString()),
            key: Key(item.title.toString()),
            value: item.done,
            onChanged: (bool? value) {
              setState(() {
                item.done = value;
              });
            },
          );
        },
      ),
    );
  }
}

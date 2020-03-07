import 'package:flutter/material.dart';
import 'package:grocerylist/models/pin_model.dart';
import 'package:grocerylist/pages/pin_entry_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grocery List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PinEntryPage(false),
    );
  }
}

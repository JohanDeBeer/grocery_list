import 'package:flutter/material.dart';
import 'package:grocerylist/blocs/pin_bloc.dart';
import 'package:grocerylist/data/bloc_provider.dart';
import 'package:grocerylist/data/root.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Grocery List',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: BlocProvider(child: Root(), bloc: PinsBloc()),
    );
  }
}

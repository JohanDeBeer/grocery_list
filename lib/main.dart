import 'package:flutter/material.dart';
import 'package:grocerylist/blocs/Item_bloc.dart';
import 'package:grocerylist/data/bloc_provider.dart';
import 'package:grocerylist/pages/home_page.dart';
import 'package:grocerylist/pages/items_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grocery List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(child: ItemsPage(), bloc: ItemsBloc(0)),
    );
  }
}

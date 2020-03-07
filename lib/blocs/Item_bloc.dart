import 'dart:async';

import 'package:grocerylist/data/bloc_provider.dart';
import 'package:grocerylist/models/Item_model.dart';

class ItemsBloc implements BlocBase {
  final _itemsController = StreamController<List<Item>>.broadcast();

  StreamSink<List<Item>> get _inItems => _itemsController.sink;

  Stream<List<Item>> get items => _itemsController.stream;

  final _addItemController = StreamController<Item>.broadcast();

  StreamSink<Item> get inAddItem => _addItemController.sink;

  ItemsBloc(int listID) {
    getItems(listID);

    _addItemController.stream.listen(_handleAddItem);
  }

  @override
  void dispose() {
    _itemsController.close();
    _addItemController.close();
  }

  void getItems(int listID) async {
    List<Item> items = await Item.getItems(listID);
    _inItems.add(items);
  }

  void _handleAddItem(Item item) async {
    await Item.newItem(item);
    getItems(item.listID);
  }
}

import 'dart:async';

import 'package:grocerylist/data/bloc_provider.dart';
import 'package:grocerylist/models/Item_model.dart';

class ViewItemBloc implements BlocBase {
  final _saveItemController = StreamController<Item>.broadcast();

  StreamSink<Item> get inSaveItem => _saveItemController.sink;

  final _deleteItemController = StreamController<int>.broadcast();

  StreamSink<int> get inDeleteItem => _deleteItemController.sink;

  final _itemDeletedController = StreamController<bool>.broadcast();

  StreamSink<bool> get _inDeleted => _itemDeletedController.sink;

  Stream<bool> get deleted => _itemDeletedController.stream;

  ViewItemBloc() {
    _saveItemController.stream.listen(_handleSaveItem);
    _deleteItemController.stream.listen(_handleDeleteItem);
  }

  @override
  void dispose() {
    _saveItemController.close();
    _deleteItemController.close();
    _itemDeletedController.close();
  }

  void _handleSaveItem(Item item) async {
    await Item.updateItem(item);
  }

  void _handleDeleteItem(int id) async {
    await Item.deleteItem(id);

    _inDeleted.add(true);
  }
}

import 'dart:async';

import 'package:grocerylist/data/bloc_provider.dart';
import 'package:grocerylist/models/shop_list_model.dart';

class ShopListsBloc implements BlocBase {
  final _shopListsController = StreamController<List<ShopList>>.broadcast();

  StreamSink<List<ShopList>> get _inShopLists => _shopListsController.sink;

  Stream<List<ShopList>> get shopLists => _shopListsController.stream;

  final _addShopListController = StreamController<ShopList>.broadcast();

  StreamSink<ShopList> get inAddShopList => _addShopListController.sink;

  ShopListsBloc() {
    getShopLists();

    _addShopListController.stream.listen(_handleAddShopList);
  }

  @override
  void dispose() {
    _shopListsController.close();
    _addShopListController.close();
  }

  void getShopLists() async {
    List<ShopList> shopLists = await ShopList.getShopLists();
    _inShopLists.add(shopLists);
  }

  void _handleAddShopList(ShopList shopList) async {
    await ShopList.newShopList(shopList);
    getShopLists();
  }
}

import 'package:flutter/material.dart';
import 'package:grocerylist/blocs/Item_bloc.dart';
import 'package:grocerylist/blocs/shop_list_bloc.dart';
import 'package:grocerylist/data/bloc_provider.dart';
import 'package:grocerylist/models/shop_list_model.dart';
import 'package:grocerylist/pages/items_page.dart';

class ShopListsPage extends StatefulWidget {
  @override
  _ShopListsPageState createState() => _ShopListsPageState();
}

class _ShopListsPageState extends State<ShopListsPage> {
  ShopListsBloc _shopListsBloc;

  @override
  void initState() {
    _shopListsBloc = BlocProvider.of<ShopListsBloc>(context);
    super.initState();
  }

  void _addShopList() async {
    ShopList shopList = new ShopList(
      name: 'johan',
    );
    _shopListsBloc.inAddShopList.add(shopList);
  }

  void _navigateToItemList(ShopList shopList) async {
    bool update = await Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => BlocProvider(
                bloc: ItemsBloc(shopList.id),
                child: ItemsPage(
                  listID: shopList.id,
                ),
              )),
    );

    if (update != null) {
      _shopListsBloc.getShopLists();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: StreamBuilder<List<ShopList>>(
          stream: _shopListsBloc.shopLists,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length == 0) {
                return Text('No ShopLists');
              }

              List<ShopList> shopLists = snapshot.data;

              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  ShopList shopList = shopLists[index];

                  return Card(
                    child: ListTile(
                      onTap: () {
                        _navigateToItemList(shopList);
                      },
                      title: Text(
                        'ShopList ${shopList.name.toString()}',
                      ),
                      subtitle: Text('id = ${shopList.id.toString()}'),
                    ),
                  );
                },
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: _addShopList,
        child: Icon(Icons.add),
      ),
    );
  }
}

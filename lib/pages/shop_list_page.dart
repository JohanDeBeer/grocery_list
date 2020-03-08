import 'package:flutter/material.dart';
import 'package:grocerylist/blocs/item_bloc.dart';
import 'package:grocerylist/blocs/shop_list_bloc.dart';
import 'package:grocerylist/data/bloc_provider.dart';
import 'package:grocerylist/models/shop_list_model.dart';
import 'package:grocerylist/pages/items_page.dart';
import 'package:grocerylist/widgets/shop_list_dialog.dart';

class ShopListsPage extends StatefulWidget {
  @override
  _ShopListsPageState createState() => _ShopListsPageState();
}

class _ShopListsPageState extends State<ShopListsPage> {
  ShopListsBloc _shopListsBloc;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _shopListsBloc = BlocProvider.of<ShopListsBloc>(context);
    super.initState();
  }

  void _editShopList(ShopList shopList) async {
    await showDialog(
        context: context,
        builder: (context) {
          return ShopListDialog(
            onSave: _updateShopList,
            shopList: shopList,
          );
        });
  }

  void _createShopList() async {
    await showDialog(
        context: context,
        builder: (context) {
          return ShopListDialog(
            shopList: ShopList(),
            onSave: _addShopList,
          );
        });
  }

  void _addShopList(ShopList shopList) async {
    _shopListsBloc.inAddShopList.add(shopList);
  }

  void _updateShopList(ShopList shopList) async {
    ShopList.updateShopList(shopList);
    _shopListsBloc.getShopLists();
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
                      //dense: true,
                      trailing: IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.teal,
                        ),
                        onPressed: () {
                          _editShopList(shopList);
                        },
                      ),
                      onTap: () {
                        _navigateToItemList(shopList);
                      },
                      title: Text(
                        '${shopList.name.toString()}',
                      ),
                      //subtitle: Text('id = ${shopList.id.toString()}'),
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
        onPressed: _createShopList,
        child: Icon(Icons.add),
      ),
    );
  }
}

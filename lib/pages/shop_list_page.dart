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

enum _ShopListMenuItems { edit, delete }

class _ShopListsPageState extends State<ShopListsPage> {
  ShopListsBloc _shopListsBloc;

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

  void _showDeleteDialog(ShopList shopList) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete ${shopList.name}?"),
          content: Text("This will remove the list and all containing Items"),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            RaisedButton(
              color: Colors.redAccent,
              onPressed: () {
                _deleteShopList(shopList);
                Navigator.pop(context);
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  void _addShopList(ShopList shopList) async {
    _shopListsBloc.inAddShopList.add(shopList);
  }

  void _updateShopList(ShopList shopList) async {
    ShopList.updateShopList(shopList);
    _shopListsBloc.getShopLists();
  }

  void _deleteShopList(ShopList shopList) async {
    ShopList.deleteShopList(shopList.id);
    _shopListsBloc.getShopLists();
  }

  void _navigateToItemList(ShopList shopList) async {
    bool update = await Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => BlocProvider(
                bloc: ItemsBloc(shopList.id),
                child: ItemsPage(
                  shopList: shopList,
                ),
              )),
    );

    if (update == true) {
      print(true);
      shopList.isDone = 1;
      ShopList.updateShopList(shopList);
      //_shopListsBloc.getShopLists();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grocery List'),
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
                      enabled: shopList.isDone != 1,
                      trailing: PopupMenuButton(
                        onSelected: (_ShopListMenuItems res) {
                          if (res == _ShopListMenuItems.edit) {
                            _editShopList(shopList);
                          } else {
                            _showDeleteDialog(shopList);
                          }
                        },
                        itemBuilder: (context) =>
                        <PopupMenuEntry<_ShopListMenuItems>>[
                          const PopupMenuItem(
                            child: Text("Edit"),
                            value: _ShopListMenuItems.edit,
                          ),
                          const PopupMenuItem(
                            child: Text("Delete"),
                            value: _ShopListMenuItems.delete,
                          ),
                        ],
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

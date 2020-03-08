import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocerylist/blocs/item_bloc.dart';
import 'package:grocerylist/blocs/item_view_bloc.dart';
import 'package:grocerylist/data/bloc_provider.dart';
import 'package:grocerylist/models/Item_model.dart';
import 'package:grocerylist/models/shop_list_model.dart';
import 'package:grocerylist/pages/item_view_page.dart';
import 'package:grocerylist/widgets/item_add_dialog.dart';

class ItemsPage extends StatefulWidget {
  ItemsPage({this.shopList});

  final ShopList shopList;

  @override
  _ItemsPageState createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  ItemsBloc _itemsBloc;
  int itemCount = 0;
  int boughtItemCount = 0;

  @override
  void initState() {
    _itemsBloc = BlocProvider.of<ItemsBloc>(context);
    super.initState();
  }

  void _navigateToItem(Item item) async {
    bool update = await Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => BlocProvider(
            bloc: ViewItemBloc(),
            child: ViewItemPage(
              item: item,
            ),
          )),
    );
    if (update != null) {
      _itemsBloc.getItems(widget.shopList.id);
    }
  }

  _addNewItem(Item item) async {
    _itemsBloc.inAddItem.add(item);
  }

  _addNewItemDialog() async {
    await showDialog(
        context: context,
        builder: (context) {
          return ItemAddDialog(
            item: Item(
              quantity: 1,
              listID: widget.shopList.id,
            ),
            onSave: _addNewItem,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.shopList.name.toString()),
      ),
      body: StreamBuilder<List<Item>>(
          stream: _itemsBloc.items,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length == 0) {
                return Text('No Items');
              }

              List<Item> items = snapshot.data;
              itemCount = items.length;
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  Item item = items[index];

                  return Card(
                    child: ListTile(
                      enabled: item.isBought != 1,
                      onTap: () {
                        _navigateToItem(item);
                      },
                      title: Text(
                        item.name.toString(),
                      ),
                      subtitle: Text('Quantity: ${item.quantity.toString()}'),
                      trailing: FlatButton(
                        onPressed: () {
                          if (item.isBought != 1) {
                            item.isBought = 1;
                            boughtItemCount++;
                            Item.updateItem(item);
                          } else {
                            item.isBought = 0;
                            boughtItemCount--;
                            Item.updateItem(item);
                          }
                          _itemsBloc.getItems(widget.shopList.id);
                          if (itemCount == boughtItemCount) {
                            Navigator.of(context).pop(true);
                          }
                        },
                        child: Text(
                          item.isBought != 1 ? "Buy" : "Undo",
                          style: TextStyle(color: Colors.teal),
                        ),
                      ),
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
        onPressed: _addNewItemDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}

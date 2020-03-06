import 'package:flutter/material.dart';
import 'package:grocerylist/blocs/Item_bloc.dart';
import 'package:grocerylist/blocs/view_item_bloc.dart';
import 'package:grocerylist/data/bloc_provider.dart';
import 'package:grocerylist/models/Item_model.dart';
import 'package:grocerylist/pages/item_view_page.dart';

class ItemsPage extends StatefulWidget {
  ItemsPage({this.listID});

  final int listID;

  @override
  _ItemsPageState createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  ItemsBloc _itemsBloc;

  @override
  void initState() {
    _itemsBloc = BlocProvider.of<ItemsBloc>(context);
    super.initState();
  }

  void _addItem() async {
    Item item = new Item(
      listID: 0,
      name: 'johan',
    );
    _itemsBloc.inAddItem.add(item);
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
      _itemsBloc.getItems(widget.listID);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: StreamBuilder<List<Item>>(
          stream: _itemsBloc.items,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length == 0) {
                return Text('No Items');
              }

              List<Item> items = snapshot.data;

              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  Item item = items[index];

                  return Card(
                    child: ListTile(
                      onTap: () {
                        _navigateToItem(item);
                      },
                      title: Text(
                        'Item ${item.name.toString()}',
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
        onPressed: _addItem,
        child: Icon(Icons.add),
      ),
    );
  }
}

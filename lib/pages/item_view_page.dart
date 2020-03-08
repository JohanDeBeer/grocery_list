import 'package:flutter/material.dart';
import 'package:grocerylist/blocs/item_view_bloc.dart';
import 'package:grocerylist/data/bloc_provider.dart';
import 'package:grocerylist/models/Item_model.dart';

class ViewItemPage extends StatefulWidget {
  ViewItemPage({Key key, this.item}) : super(key: key);

  final Item item;

  @override
  _ViewItemPageState createState() => _ViewItemPageState();
}

class _ViewItemPageState extends State<ViewItemPage> {
  ViewItemBloc _viewItemBloc;
  TextEditingController _itemController = new TextEditingController();
  GlobalKey<FormState> _key = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _viewItemBloc = BlocProvider.of<ViewItemBloc>(context);
    _itemController.text = widget.item.name;
  }

  void _saveItem() async {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      _viewItemBloc.inSaveItem.add(widget.item);
    }
  }

  void _deleteItem() {
    // Add the item id to the delete item stream. This triggers the function
    // we set in the listener.
    _viewItemBloc.inDeleteItem.add(widget.item.id);

    // Wait for `deleted` to be set before popping back to the main page. This guarantees there's no
    // mismatch between what's stored in the database and what's being displayed on the page.
    // This is usually only an issue with more database heavy actions, but it's a good thing to
    // add regardless.
    _viewItemBloc.deleted.listen((deleted) {
      if (deleted) {
        // Pop and return true to let the main page know that a item was deleted and that
        // it has to update the item stream.
        Navigator.of(context).pop(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item ' + widget.item.id.toString()),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveItem,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _deleteItem,
          ),
        ],
      ),
      body: Form(
        key: _key,
        child: Container(
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: widget.item.name != null ? widget.item.name : '',
                onSaved: (val) {
                  widget.item.name = val;
                },
                validator: (val) {
                  if (val.isNotEmpty) {
                    return null;
                  } else {
                    return 'Please add a name';
                  }
                },
              ),
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.add_circle),
                    onPressed: () {
                      setState(() {
                        widget.item.quantity = 1;
                      });
                    },
                  ),
                  Text(widget.item.quantity.toString()),
                  IconButton(
                      icon: Icon(Icons.do_not_disturb_on), onPressed: () {})
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

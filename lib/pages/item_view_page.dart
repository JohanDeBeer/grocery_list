import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      Navigator.of(context).pop(true);
    }
  }

  void _deleteItem() {
    _viewItemBloc.inDeleteItem.add(widget.item.id);
    _viewItemBloc.deleted.listen((deleted) {
      if (deleted) {
        Navigator.of(context).pop(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.name),
      ),
      body: Form(
        key: _key,
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: 30),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(labelText: "Item Name"),
                      initialValue: widget.item.name,
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
                    TextFormField(
                      decoration: InputDecoration(labelText: "Quantity"),
                      initialValue: widget.item.quantity != null
                          ? widget.item.quantity.toString()
                          : '',
                      keyboardType: TextInputType.numberWithOptions(),
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly,
                      ],
                      onSaved: (val) {
                        widget.item.quantity = int.parse(val);
                      },
                      validator: (val) {
                        if (val != null) {
                          if (int.parse(val) > 0) {
                            return null;
                          } else {
                            return "Please add a positve number";
                          }
                        } else {
                          return "Please add an amount";
                        }
                      },
                    )
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                child: RaisedButton(
                  color: Colors.teal,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  onPressed: _saveItem,
                  child: Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                child: OutlineButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  borderSide: BorderSide(color: Colors.red, width: 2),
                  onPressed: _deleteItem,
                  child: Text(
                    "Delete",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

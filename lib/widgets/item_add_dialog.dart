import 'package:flutter/material.dart';
import 'package:grocerylist/models/Item_model.dart';

class ItemAddDialog extends StatefulWidget {
  ItemAddDialog({this.onSave, this.item});

  final onSave;
  final Item item;

  @override
  _ItemAddDialogState createState() => _ItemAddDialogState();
}

class _ItemAddDialogState extends State<ItemAddDialog> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add New Item"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              validator: (val) {
                return val.isEmpty ? "Please enter a name" : null;
              },
              onSaved: (val) {
                widget.item.name = val;
                widget.onSave(widget.item);
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancel"),
        ),
        RaisedButton(
          color: Colors.teal,
          onPressed: () {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              Navigator.pop(context);
            }
          },
          child: Text("Save"),
        )
      ],
    );
  }
}

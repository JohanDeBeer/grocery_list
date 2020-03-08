import 'package:flutter/material.dart';
import 'package:grocerylist/models/shop_list_model.dart';

class ShopListDialog extends StatefulWidget {
  ShopListDialog({
    this.shopList,
    this.onSave,
  });

  final ShopList shopList;
  final Function onSave;

  @override
  _ShopListDialogState createState() => _ShopListDialogState();
}

class _ShopListDialogState extends State<ShopListDialog> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    bool isNew = widget.shopList.name == null ? true : false;
    return AlertDialog(
      title: Text("${isNew ? "New" : "Edit"} Grocery List"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              initialValue: widget.shopList.name,
              validator: (val) {
                return val.isEmpty ? "Please enter a name" : null;
              },
              onSaved: (val) {
                widget.shopList.name = val;
                widget.onSave(widget.shopList);
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

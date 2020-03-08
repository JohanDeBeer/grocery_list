import 'package:grocerylist/data/database.dart';

class Item {
  int id;
  String name;
  int quantity;
  int isBought;
  int listID;

  Item({
    this.id,
    this.name,
    this.quantity,
    this.isBought,
    this.listID,
  });

  factory Item.fromJson(Map<String, dynamic> json) => new Item(
    id: json["id"],
    name: json["name"],
    quantity: json["quantity"],
    isBought: json["isBought"],
    listID: json["listID"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "quantity": quantity,
    "isBought": isBought,
    "listID": listID,
  };

  static newItem(Item item) async {
    final db = await DBProvider.db.database;
    var res = await db.insert('item', item.toJson());

    return res;
  }

  static getItem(int id) async {
    final db = await DBProvider.db.database;
    var res = await db.query('item', where: 'id = ?', whereArgs: [id]);

    return res.isNotEmpty ? Item.fromJson(res.first) : null;
  }

  static getItems(int listID) async {
    final db = await DBProvider.db.database;
    var res = await db.query('item', where: 'listID = ?', whereArgs: [listID]);
    List<Item> items =
    res.isNotEmpty ? res.map((item) => Item.fromJson(item)).toList() : [];

    return items;
  }

  static updateItem(Item item) async {
    final db = await DBProvider.db.database;
    var res = await db
        .update('item', item.toJson(), where: 'id = ?', whereArgs: [item.id]);

    return res;
  }

  static deleteItem(int id) async {
    final db = await DBProvider.db.database;

    db.delete('item', where: 'id = ?', whereArgs: [id]);
  }
}

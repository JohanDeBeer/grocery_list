import 'package:grocerylist/data/database.dart';

class ShopList {
  int id;
  String name;
  int isDone;
  int itemCount;

  ShopList({
    this.id,
    this.name,
    this.isDone,
  });

  factory ShopList.fromJson(Map<String, dynamic> json) => new ShopList(
        id: json["id"],
        name: json["name"],
        isDone: json["isDone"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "isDone": isDone,
      };

  static newShopList(ShopList shopList) async {
    final db = await DBProvider.db.database;
    var res = await db.insert('shopList', shopList.toJson());

    return res;
  }

  static getShopList(int id) async {
    final db = await DBProvider.db.database;
    var res = await db.query('shopList', where: 'id = ?', whereArgs: [id]);

    return res.isNotEmpty ? ShopList.fromJson(res.first) : null;
  }

  static getShopLists() async {
    final db = await DBProvider.db.database;
    var res = await db.query('shopList', orderBy: 'isDone');
    List<ShopList> shopLists = res.isNotEmpty
        ? res.map((shopList) => ShopList.fromJson(shopList)).toList()
        : [];

    return shopLists;
  }

  static updateShopList(ShopList shopList) async {
    final db = await DBProvider.db.database;
    var res = await db.update('shopList', shopList.toJson(),
        where: 'id = ?', whereArgs: [shopList.id]);

    return res;
  }

  static deleteShopList(int id) async {
    final db = await DBProvider.db.database;

    db.delete('shopList', where: 'id = ?', whereArgs: [id]);
  }
}

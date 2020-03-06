import 'dart:io';
import 'package:grocerylist/models/Item_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();
  Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await initDB();

    return _database;
  }

  initDB() async {
    Directory docDir = await getApplicationDocumentsDirectory();
    String path = join(docDir.path, 'app.db');

    return await openDatabase(path, version: 2, onOpen: (db) async {},
        onCreate: (Database db, int version) async {
      await db.execute('''
      CREATE TABLE item(
        id INTEGER PRIMARY KEY,
        name TEXT DEFAULT '',
        quantity INTEGER DEFAULT 1,
        isBought BIT DEFAULT 0,
        listID INTEGER
      )
      ''');
    });
  }

  newItem(Item item) async {
    final db = await database;
    var res = await db.insert('item', item.toJson());

    return res;
  }

  getItem(int id) async {
    final db = await database;
    var res = await db.query('item', where: 'id = ?', whereArgs: [id]);

    return res.isNotEmpty ? Item.fromJson(res.first) : null;
  }

  getItems() async {
    final db = await database;
    var res = await db.query('item');
    List<Item> items =
        res.isNotEmpty ? res.map((item) => Item.fromJson(item)).toList() : [];

    return items;
  }

  updateItem(Item item) async {
    final db = await database;
    var res = await db
        .update('item', item.toJson(), where: 'id = ?', whereArgs: [item.id]);

    return res;
  }

  deleteItem(int id) async {
    final db = await database;

    db.delete('item', where: 'id = ?', whereArgs: [id]);
  }
}

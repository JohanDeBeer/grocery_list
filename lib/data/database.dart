import 'dart:io';
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

    return await openDatabase(path, version: 1, onOpen: (db) async {},
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
      await db.execute('''
      CREATE TABLE shopList(
        id INTEGER PRIMARY KEY,
        name TEXT DEFAULT '',
        isDone BIT DEFAULT 0
      )
      ''');
      await db.execute('''
      CREATE TABLE pin(
        id INTEGER PRIMARY KEY,
        value TEXT
      )
      ''');
    });
  }
}

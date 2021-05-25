import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDatabase();
    return _database;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'account_book.db');

    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      db.execute('''
        CREATE TABLE category (
          "id"	INTEGER,
          "name"	TEXT NOT NULL,
          "type"	INTEGER NOT NULL,
          PRIMARY KEY("id" AUTOINCREMENT)
        )'''
      );
      await initCategory(db);

      return db.execute('''
        CREATE TABLE daily_cost (
          "id"	INTEGER,
          "category"	INTEGER NOT NULL,
          "title"	TEXT NOT NULL,
          "asset_type"	INTEGER NOT NULL,
          "price"	INTEGER NOT NULL,
          "date"	TEXT,
          PRIMARY KEY("id" AUTOINCREMENT)
        )'''
      );
    }, onUpgrade: (db, oldVersion, newVersion) {});
  }

  // 카테고리 초기화
  Future initCategory(Database db) async {
    Batch batch = db.batch();

    String sql = await rootBundle.loadString("assets/sql/init_data.sql");

    List<String> list = sql.split(";");
    for(var category in list)
      if(category.isNotEmpty)
        batch.rawInsert(category);

    await batch.commit();
    return true;
  }
}



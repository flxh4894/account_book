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

    return await openDatabase(path, version: 4, onCreate: (db, version) async {
      db.execute('''
        CREATE TABLE category (
          "id"	INTEGER,
          "name"	TEXT NOT NULL,
          "type"	INTEGER NOT NULL,
          PRIMARY KEY("id" AUTOINCREMENT)
        )'''
      );
      db.execute('''
        CREATE TABLE "assets" (
          "id"	INTEGER,
          "name"	TEXT NOT NULL,
          "memo"	TEXT NOT NULL,
          "type"	INTEGER NOT NULL DEFAULT 1,
          "is_favorite"	INTEGER NOT NULL DEFAULT 0,
          PRIMARY KEY("id" AUTOINCREMENT)
        )'''
      );
      await initCategory(db);

      db.execute('''
        CREATE TABLE "credit_card" (
          "id"	INTEGER,
          "asset_id"	INTEGER NOT NULL,
          "card_nm"	TEXT NOT NULL,
          "tag"	TEXT NOT NULL,
          "performance"	INTEGER NOT NULL,
          "pay_date"	INTEGER NOT NULL,
          PRIMARY KEY("id" AUTOINCREMENT),
          FOREIGN KEY("asset_id") REFERENCES "assets"("id")
        )'''
      );

      db.execute('''
        CREATE TABLE "year_goal" (
          "id"	INTEGER,
          "year"	INTEGER NOT NULL,
          "price"	INTEGER NOT NULL,
          PRIMARY KEY("id" AUTOINCREMENT)
        )'''
      );

      db.execute('''
        CREATE TABLE "sms_asset_matcher" (
          "id"	INTEGER,
          "word"	TEXT NOT NULL,
          "asset_id"	INTEGER NOT NULL,
          PRIMARY KEY("id" AUTOINCREMENT)
        )'''
      );

      return db.execute('''
        CREATE TABLE "daily_cost" (
          "id"	INTEGER,
          "category"	INTEGER NOT NULL,
          "title"	BLOB NOT NULL,
          "asset_id"	INTEGER NOT NULL,
          "asset_type"	INTEGER NOT NULL DEFAULT 1,
          "price"	INTEGER NOT NULL,
          "date"	TEXT NOT NULL,
          FOREIGN KEY("asset_id") REFERENCES "assets"("id"),
          PRIMARY KEY("id" AUTOINCREMENT)
        )'''
      );
    }, onUpgrade: (db, oldVersion, newVersion) async {
      await initCategory(db);

      return db.execute('''
        CREATE TABLE "sms_asset_matcher" (
          "id"	INTEGER,
          "word"	TEXT NOT NULL,
          "asset_id"	INTEGER NOT NULL,
          PRIMARY KEY("id" AUTOINCREMENT)
        )'''
      );
    });
  }

  // ???????????? ?????????
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



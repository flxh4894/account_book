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

    return await openDatabase(path, version: 1, onCreate: (db, version) {
      db.execute('''
        CREATE TABLE "daily_cost" (
          "id"	INTEGER,
          "category"	INTEGER NOT NULL,
          "title"	TEXT NOT NULL,
          "asset_id"	INTEGER NOT NULL,
          "price"	INTEGER NOT NULL,
          "date"	TEXT,
          PRIMARY KEY("id" AUTOINCREMENT)
        )'''
      );
      return db.execute('''
        CREATE TABLE stock_list (
          "id"	INTEGER,
          "diary_id"	INTEGER NOT NULL,
          "name"	TEXT NOT NULL,
          "deal_type"	NUMERIC NOT NULL,
          "price"	INTEGER NOT NULL,
          "amount"	INTEGER NOT NULL,
          "date"	TEXT,
          FOREIGN KEY("diary_id") REFERENCES "diary"("id"),
          PRIMARY KEY("id" AUTOINCREMENT)
        )'''
      );
    }, onUpgrade: (db, oldVersion, newVersion) {});
  }
}

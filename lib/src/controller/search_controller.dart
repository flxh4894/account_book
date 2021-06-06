import 'package:accountbook/src/helper/db_helper.dart';
import 'package:accountbook/src/model/asset_content.dart';
import 'package:accountbook/src/model/asset_info.dart';
import 'package:accountbook/src/model/daily_cost.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

class SearchController extends GetxController {
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await DatabaseHelper().database;
    return _database;
  }
  RxList<AssetContent> assetContentList = <AssetContent>[].obs;
  RxList<DailyCost> dailyCostList = <DailyCost>[].obs;

  @override
  void onInit() {
    getAllAccountBook();
    super.onInit();
  }

  void getAllAccountBook() async {
    final db = await database;

    var list = await db.query("daily_cost", groupBy: "title");
    assetContentList( list.map((e) => AssetContent.fromJson(e)).toList() );
  }

  void getContentsFromTitle(String title) async {
    final db = await database;

    var list = await db.rawQuery(
        "SELECT "
            "A.id, "
            "A.title, "
            "A.price, "
            "A.date, "
            "B.id AS category_id, "
            "B.name AS category, "
            "B.type AS type, "
            "C.id AS asset_id, "
            "C.name AS asset_nm " +
        "FROM "
            "daily_cost A, category B, assets C "
        "WHERE A.title = '$title' "
            "AND A.category = B.id "
            "AND A.asset_id = C.id " +
        "ORDER BY date desc");

    dailyCostList( list.map((e) => DailyCost.fromJson(e)).toList() );
  }
}
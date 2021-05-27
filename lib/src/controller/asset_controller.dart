import 'package:accountbook/src/helper/db_helper.dart';
import 'package:accountbook/src/model/asset_info.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqlite_api.dart';

class AssetController extends GetxController {

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await DatabaseHelper().database;
    return _database;
  }

  RxList<AssetInfo> assetInfoList = <AssetInfo>[].obs;
  RxString assetNm = ''.obs;
  RxInt assetId = (-1).obs;

  @override
  void onInit() {
    getAssetInfoList();
    super.onInit();
  }

  void getAssetInfoList() async {
    final db = await database;
    var list = await db.query("assets", orderBy: "is_favorite DESC");
    assetInfoList( list.map((e) => AssetInfo.fromJson(e)).toList() );
  }

  void insertAssetInfo(AssetInfo assetInfo) async {
    final db = await database;
    db.insert("assets", assetInfo.toMap());
    getAssetInfoList();
  }

  void updateFavorite(int isFavorite, int id) async {
    final db = await database;
    db.update("assets", {'is_favorite': isFavorite}, where: "id = ?", whereArgs: [id]);

    getAssetInfoList();
  }

}
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
  RxBool deleteFlag = false.obs;

  @override
  void onInit() {
    getAssetInfoList();
    super.onInit();
  }

  // 자산목록 가져오기
  void getAssetInfoList() async {
    final db = await database;
    var list = await db.query("assets", orderBy: "is_favorite DESC", where: "id != ?", whereArgs: [-1]);
    assetInfoList( list.map((e) => AssetInfo.fromJson(e)).toList() );
  }

  // 자산목록 삽입
  void insertAssetInfo(AssetInfo assetInfo) async {
    final db = await database;
    db.insert("assets", assetInfo.toMap());
    getAssetInfoList();
  }

  // 자산목록 수정(업데이트)
  void updateAssetInfo(AssetInfo assetInfo) async {
    final db = await database;
    await db.update("assets", assetInfo.toMap(), where: "id = ?", whereArgs: [assetInfo.id]);
    getAssetInfoList();
  }

  // 자산목록 삭제
  void deleteAssetInfo(int id) async {
    selectAssetInDailyCost(id); // 삭제 전 가계부에 입력 된 상태인지 다시 확인

    if(deleteFlag.value){
      final db = await database;
      await db.delete("assets",where: "id = ?", whereArgs: [id]);
      getAssetInfoList();
      Get.back();
    } else {
      Get.snackbar("오류", "삭제가 불가능 합니다.");
    }

  }

  // 자산 즐겨찾기 업데이트(상태값)
  void updateFavorite(int isFavorite, int id) async {
    final db = await database;
    db.update("assets", {'is_favorite': isFavorite}, where: "id = ?", whereArgs: [id]);

    getAssetInfoList();
  }

  // 가계부에 해당 자산으로 작성된 목록이 있는지 확인
  // 자산목록 삭제 가능 여부 확인을 위함
  void selectAssetInDailyCost(int id) async {
    final db = await database;
    var list = await db.query("daily_cost", where: "asset_id = ?", whereArgs: [id]);

    if(list.length == 0)
      deleteFlag(true);
    else
      deleteFlag(false);
  }

}
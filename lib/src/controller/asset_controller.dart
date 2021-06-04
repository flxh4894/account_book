import 'package:accountbook/src/helper/db_helper.dart';
import 'package:accountbook/src/model/asset_info.dart';
import 'package:accountbook/src/model/daily_cost.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqlite_api.dart';

enum BaseAsset {Cash, Bank, Invest, Loan, Else}
class AssetController extends GetxController {

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await DatabaseHelper().database;
    return _database;
  }

  RxList<AssetInfo> assetInfoList = <AssetInfo>[].obs;
  RxList<AssetInfo> baseAssetList = <AssetInfo>[].obs;
  RxMap<int, dynamic> baseAssetSumList = <int, dynamic>{}.obs;
  RxString assetNm = ''.obs;
  RxInt assetId = (-1).obs;
  RxBool deleteFlag = false.obs;

  @override
  void onInit() {
    selectBaseAssetGroup(); // 초기 자본금 합계 불러오기
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

  // 선택 자산 목록 가져오기 (나의자산 +버튼 => 은행, 투자, 대출 등 특정 자산목록만)
  void selectBaseAssetList(int type) async {
    final db = await database;
    var list = await db.query("assets", orderBy: "is_favorite DESC", where: "id != ? AND type = ?", whereArgs: [-1, type]);
    baseAssetList( list.map((e) => AssetInfo.fromJson(e)).toList() );

    baseAssetList.forEach((element) {
      print(element.toMap());
    });
  }

  // 선택 자산목록 삽입 - (나의 자산 분류별 금액 입력)
  void insertBaseAssetInfo(DailyCost dailyCost) async {
    final db = await database;
    print(dailyCost.toMap());

    var list = await db.query("daily_cost", where: "asset_id = ? AND date = ?", whereArgs: [dailyCost.assetId, "000000000000"]);
    if(list.length == 0){
      db.insert("daily_cost", dailyCost.toMap());
    } else {
      db.update("daily_cost", dailyCost.toMapNoId(), where: "id = ?", whereArgs: [list[0]['id']] );
    }

    selectBaseAssetGroup();
  }

  // 초기자산 그룹화 출력 - (나의 자산 분류별 금액)
  void selectBaseAssetGroup() async {
    final db = await database;

    var list = await db.rawQuery(
        "SELECT "
            "B.type, "
            "sum(A.price) AS price "
            "FROM "
            "daily_cost A, "
            "assets B "
            "WHERE "
            "A.asset_id = B.id "
            "GROUP BY B.type "
    );

    Map<int, dynamic> data = Map.fromIterable(list, key: (e) => e['type'], value: (e) => e['price']);
    baseAssetSumList(data);
  }

  Future<List> selectAssetTypeList(int type) async {
    final db = await database;
    var list = await db.rawQuery(
        "SELECT "
            "B.name AS name, "
            "B.memo AS tag, "
            "sum(price) AS price "
        "FROM "
            "daily_cost A, "
            "assets B "
        "WHERE "
            "A.asset_id = B.id "
            "AND B.type = $type "
        "GROUP BY A.asset_id");

    return list;
  }
}
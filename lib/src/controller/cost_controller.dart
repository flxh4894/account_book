import 'package:accountbook/src/controller/util_controller.dart';
import 'package:accountbook/src/helper/db_helper.dart';
import 'package:accountbook/src/model/asset_content.dart';
import 'package:accountbook/src/model/category.dart';
import 'package:accountbook/src/model/daily_cost.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class CostController extends GetxController {
  static Database _database;

  final UtilController _utilController = Get.find<UtilController>();
  RxList assetList = [].obs;
  RxMap<String, List<DailyCost>> dailyCostList =
      <String, List<DailyCost>>{}.obs; // 당일 가계부 리스트 ('0521': [리스트]) 형식
  RxList<DailyCost> costContentList = <DailyCost>[].obs; // 한달치 가계부 리스트
  RxList<Category> categoryList = <Category>[].obs;
  RxInt monthTotalPlus = 0.obs;
  RxInt monthTotalMinus = 0.obs;
  RxInt monthTotal = 0.obs;

  @override
  void onInit() {
    init();
    super.onInit();
  }

  void init() async {
    await getMonthCostContent(_utilController.date);
    getCategoryList();
  }

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await DatabaseHelper().database;
    return _database;
  }

  // 월별 소비 내역 가져오기
  Future<bool> getMonthCostContent(DateTime date) async {
    final db = await database;
    final year = date.year;
    final month = date.month < 10 ? '0${date.month}' : date.month;
    final yearMonth = '$year$month';

    var list = await db.rawQuery(
        "SELECT A.id, A.title, A.asset_type, A.price, A.date, B.name AS category, B.type AS type " +
            "FROM daily_cost A, category B WHERE A.category = B.id " +
            "AND A.date BETWEEN '${yearMonth}01' AND '${yearMonth}31'  ORDER BY date desc");

    dailyCostList.clear();
    int plus = 0;
    int minus = 0;

    costContentList(list.map((e) => DailyCost.fromJson(e)).toList());
    // 당일 내역 일별 복사
    list.forEach((element) {
      String day = element['date'].toString().substring(6, 8);
      if (dailyCostList[day] == null)
        dailyCostList[day] = [DailyCost.fromJson(element)];
      else
        dailyCostList[day] = [
          ...dailyCostList[day],
          DailyCost.fromJson(element)
        ];

      if (DailyCost.fromJson(element).type == 1)
        plus += DailyCost.fromJson(element).price;
      else
        minus += DailyCost.fromJson(element).price;
    });
    monthTotalPlus(plus);
    monthTotalMinus(minus);

    setAssetList();
    return true;
  }

  // 새로운 소비 내역 저장하기
  void insertCostContent(AssetContent assetContent) async {
    final db = await database;

    await db.insert("daily_cost", assetContent.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    getMonthCostContent(_utilController.date);
    Get.back();
  }

  // 자산 내역 출력하기
  void setAssetList() {
    monthTotal( monthTotalPlus.value - monthTotalMinus.value );
    List<Map<String, dynamic>> data = [];
    data.add( {'title': '수입', 'money': monthTotalPlus.value, 'id': 1});
    data.add( {'title': '지출', 'money': monthTotalMinus.value * -1, 'id': 2});
    data.add( {'title': '할부금', 'money': 0, 'id': 3});
    data.add( {'title': '잔액', 'money': monthTotal.value, 'id': 3});
    assetList(data);
  }

  // 달력 하단 당일 메모 출력리스트 생성 (달력 이벤트)
  List<DailyCost> getEventsForDay(DateTime day) {
    String _day = DateFormat('yyyyMMdd').format(day).toString();
    List<DailyCost> list = <DailyCost>[];

    costContentList.forEach((e) {
      if (_day == e.date.substring(0, 8)) list.add(e);
    });

    return list;
  }

  // 카테고리 목록 가져오기
  void getCategoryList() async {
    final db = await database;

    var list = await db.query("category");
    categoryList(list.map((e) => Category.fromJson(e)).toList());
  }


}

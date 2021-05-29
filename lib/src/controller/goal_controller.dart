import 'package:accountbook/src/helper/db_helper.dart';
import 'package:accountbook/src/model/invest_info.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

class GoalController extends GetxController {
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await DatabaseHelper().database;
    return _database;
  }

  RxList<int> monthAssetList = <int>[].obs;
  RxInt yearTotalAsset = 0.obs;
  RxList<InvestInfo> yearInvestList = <InvestInfo>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  void init(){
    monthAssetList.clear();
    yearTotalAsset(0);
    yearInvestList.clear();

    getMonthTotalAsset();
    getYearInvest();
  }

  // 월별 수익
  Future<List> getMonthIncome(Database db) async {
    var list = await db.rawQuery(
        "SELECT sum(price) AS 'price', substr(date,5,2) AS 'date' "
        "FROM daily_cost "
        "WHERE asset_type = 1 "
        "GROUP by substr(date,1,6)");
    List data = List.generate(12, (i) => 0);

    list.forEach((element) {
      var month = int.parse(element['date'].toString());
      data[month-1] = element['price'];
    });

    return data;
  }

  // 월별 지출
  Future<List> getMonthExpense(Database db) async {
    var list = await db.rawQuery(
        "SELECT sum(price) AS 'price', substr(date,5,2) AS 'date' "
            "FROM daily_cost "
            "WHERE asset_type = 2 "
            "GROUP by substr(date,1,6)");
    List data = List.generate(12, (i) => 0);

    list.forEach((element) {
      var month = int.parse(element['date'].toString());
      data[month-1] = element['price'];
    });

    return data;
  }

  // 월별 투자
  Future<List> getMonthInvest(Database db) async {
    var list = await db.rawQuery(
        "SELECT sum(price) AS 'price', substr(date,5,2) AS 'date' "
            "FROM daily_cost "
            "WHERE asset_type = 3 "
            "GROUP by substr(date,1,6)");
    List data = List.generate(12, (i) => 0);

    list.forEach((element) {
      var month = int.parse(element['date'].toString());
      data[month-1] = element['price'];
    });

    return data;
  }

  // 1년간 투자 내역
  void getYearInvest() async {
    final db = await database;

    var list = await db.rawQuery(
        "SELECT B.name, B.memo, B.id, SUM(A.price) AS 'price' "
        "FROM daily_cost A, assets B "
        "WHERE A.asset_id = B.id AND A.asset_type = 3 "
        "GROUP BY B.id");

    yearInvestList( list.map((e) => InvestInfo.fromJson(e)).toList() );

    yearTotalAsset(0);
    yearInvestList.forEach((element) {
      yearTotalAsset( yearTotalAsset.value + element.price );
    });
  }

  void getMonthTotalAsset() async {
    final db = await database;

    var income = await getMonthIncome(db);
    var expense = await getMonthExpense(db);
    var invest = await getMonthInvest(db);

    for(int i=0; i<12; i++) {
      monthAssetList.add(income[i] - expense[i] - invest[i]);
    }

    var totalCash = 0;
    monthAssetList.forEach((element) {
      totalCash += element;
    });

    yearInvestList.add(
        new InvestInfo(
            assetId: -1,
            price: totalCash,
            title: '현금',
            tag: '보유현금 \n#사용에 따라 마이너스 표기 가능')
    );
    yearTotalAsset(yearTotalAsset.value + totalCash);

    print(monthAssetList.toString());
  }

}
import 'package:accountbook/src/helper/db_helper.dart';
import 'package:accountbook/src/model/invest_info.dart';
import 'package:accountbook/src/model/year_goal.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

class GoalController extends GetxController {
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await DatabaseHelper().database;
    return _database;
  }

  RxList<int> monthAssetList = <int>[].obs; // 월별 저축금액 리스트
  RxInt yearTotalAsset = 0.obs; // 1년간 총 모은 금액
  RxList<InvestInfo> yearInvestList = <InvestInfo>[].obs; // 1년간 저축한 리스트
  Rx<YearGoal> goal = new YearGoal(year: DateTime.now().year, id: -1, price: 0).obs;

  @override
  void onInit() {
    super.onInit();
  }

  void init(){
    monthAssetList.clear();
    yearInvestList.clear();
    selectYearGoal();
    getMonthTotalAsset();
    getYearInvest();
  }

  // 월별 수익
  Future<List> getMonthIncome(Database db) async {
    final date = DateTime.now();
    final year = date.year;
    final month = date.month < 10 ? '0${date.month}' : date.month;
    final yearMonth = '$year$month';
    var list = await db.rawQuery(
        "SELECT sum(price) AS 'price', substr(date,5,2) AS 'date' "
        "FROM daily_cost "
        "WHERE asset_type = 1 AND "
        "date BETWEEN ${yearMonth}01010000 AND ${yearMonth}12312359 "
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
    final date = DateTime.now();
    final year = date.year;
    final month = date.month < 10 ? '0${date.month}' : date.month;
    final yearMonth = '$year$month';
    var list = await db.rawQuery(
        "SELECT sum(price) AS 'price', substr(date,5,2) AS 'date' "
            "FROM daily_cost "
            "WHERE asset_type = 2 AND "
            "date BETWEEN ${yearMonth}01010000 AND ${yearMonth}12312359 "
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
    final date = DateTime.now();
    final year = date.year;
    final month = date.month < 10 ? '0${date.month}' : date.month;
    final yearMonth = '$year$month';
    var list = await db.rawQuery(
        "SELECT sum(price) AS 'price', substr(date,5,2) AS 'date' "
            "FROM daily_cost "
            "WHERE asset_type = 3 AND "
            "date BETWEEN ${yearMonth}01010000 AND ${yearMonth}12312359 "
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
    final date = DateTime.now();
    final year = date.year;
    final month = date.month < 10 ? '0${date.month}' : date.month;
    final yearMonth = '$year$month';

    var list = await db.rawQuery(
        "SELECT B.name, B.memo, B.id, SUM(A.price) AS 'price' "
        "FROM daily_cost A, assets B "
        "WHERE A.asset_id = B.id AND A.asset_type = 3 AND "
        "date BETWEEN ${yearMonth}01010000 AND ${yearMonth}12312359 "
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
      monthAssetList.add(income[i] - expense[i] );
    }

    var totalCash = 0;
    var index = 0;
    monthAssetList.forEach((element) {
      totalCash += element - invest[index];
      index ++ ;
    });

    // 작년 금액으로 투자를 한 경우
    if(totalCash < 0)  {
      yearInvestList.add(
          new InvestInfo(
              assetId: -1,
              price: 0,
              title: '현금',
              tag: '보유현금 \n#사용에 따라 마이너스 표기 가능')
      );
      yearInvestList.add(
          new InvestInfo(
              assetId: -1,
              price: totalCash,
              title: '작년 저축 금액',
              tag: '투자에 사용한 작년까지의 저축 금액')
      );
    } else {
      yearInvestList.add(
          new InvestInfo(
              assetId: -1,
              price: totalCash,
              title: '현금',
              tag: '보유현금 \n#사용에 따라 마이너스 표기 가능')
      );
    }
    yearTotalAsset(0);
    yearTotalAsset(yearTotalAsset.value + totalCash);
  }

  // 1년 목표금액 가져오기
  void selectYearGoal() async {
    final db = await database;
    var year = DateTime.now().year.toString();
    var list = await db.query("year_goal", where: "year = ?", whereArgs: [year], limit: 1);

    if(list.length == 0)
      goal(new YearGoal(year: DateTime.now().year, id: -1, price: 0));
    else
      goal( new YearGoal.fromJson(list[0])  );
  }

  // 1년 목표금액 설정하기
  void insertYearGoal(int price) async {
    final db = await database;
    var year = DateTime.now().year;

    var check = await db.query("year_goal", where: "year = ?", whereArgs: [year]);
    if(check.length == 0){
      var id = await db.insert("year_goal", {'year': year, 'price': price});
      goal(new YearGoal(year: year, price: price, id: id));
    } else {
      await db.update("year_goal", {'year': year, 'price': price}, where: "year = ?", whereArgs: [year]);
      var id = goal.value.id;
      goal(new YearGoal(year: year, price: price, id: id));
    }

  }

}
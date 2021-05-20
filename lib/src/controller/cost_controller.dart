import 'package:accountbook/src/helper/db_helper.dart';
import 'package:accountbook/src/model/daily_cost.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

class CostController extends GetxController {
  static Database _database;

  RxMap<String, List<DailyCost>> dailyCostList = <String, List<DailyCost>>{}.obs;

  @override
  void onInit() {
    getMonthCostContent();
    super.onInit();
  }

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await DatabaseHelper().database;
    return _database;
  }

  void getMonthCostContent() async {
    final db = await database;
    var list = await db.rawQuery(
        "SELECT A.id, A.title, A.asset_id, A.price, A.date, B.name AS category, B.type AS type " +
            "FROM daily_cost A, category B WHERE A.category = B.id ORDER BY date desc");
    list.forEach((element) {
      String day = element['date'].toString().substring(6,8);
      if(dailyCostList[day] == null)
        dailyCostList[day] = [DailyCost.fromJson(element)];
      else
        dailyCostList[day] = [...dailyCostList[day], DailyCost.fromJson(element)];
    });

    dailyCostList.forEach((key, value) {
      print(key);
      for(var cost in value){
        print(cost.toMap());
      }
    });
  }
}

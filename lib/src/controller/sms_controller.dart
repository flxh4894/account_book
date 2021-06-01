import 'package:accountbook/src/controller/cost_controller.dart';
import 'package:accountbook/src/helper/db_helper.dart';
import 'package:accountbook/src/model/asset_content.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sms/sms.dart';
import 'package:sqflite/sqflite.dart';

class SmsController extends GetxController{
  final CostController _costController = Get.find<CostController>();
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await DatabaseHelper().database;
    return _database;
  }
  List<AssetContent> smsList = <AssetContent>[];

  @override
  void onInit() {
    getLastSmsDate();
    super.onInit();
  }

  void receiveSms(SmsMessage msg) {
      smsList.clear();

      var price = _parsePrice(msg.body);
      // 가격정보가 없거나, 승인이 거절된 내용은 빼버림
      if(price == null || msg.body.contains("승인거절")) {
        return;
      }

      var date = DateFormat('yyyyMMddhhmm').format(msg.date);
      var text = _parseDate(msg.body, price);
      price = price.replaceAll(",", "").replaceAll("원", "");

      smsList.add(
          AssetContent(
              date: date,
              title: text,
              price: int.parse(price),
              category: 17,
              assetType: 2,
              assetId: 1
          )
      );
      smsList.forEach((element) {
        print(element.toMap());
      });
      insertSmsContent(smsList);
  }
  
  void getLastSmsDate() async {
    final db = await database;
    
    var list = await db.query("daily_cost", orderBy: "date DESC", limit: 1);
    if(list.length == 0)
      print('데이터가 없습니다.');
    else {
      AssetContent lastDate = AssetContent.fromJson(list[0]);

      // 데이터가 있다면
      // 가장 마지막 저장된 가계부 정보의 날짜와 비교해서 뒤의 메모만 가져온다.
      smsList.clear();
      SmsQuery query = new SmsQuery();
      var dbList = await query.querySms();

      dbList.forEach((element) {
        var date = DateFormat('yyyyMMddhhmm').format(element.date);
        if( int.parse(date) > int.parse(lastDate.date) ){

          var price = _parsePrice(element.body);

          // 가격정보가 없거나, 승인이 거절된 내용은 빼버림
          if(price == null || element.body.contains("승인거절")) {
            return;
          }

          var text = _parseDate(element.body, price);
          price = price.replaceAll(",", "").replaceAll("원", "");

          smsList.add(
              AssetContent(
                  date: date,
                  title: text,
                  price: int.parse(price),
                  category: 17,
                  assetType: 2,
                  assetId: 1
              )
          );
        }
      });

      insertSmsContent(smsList);
    }
  }

  String _parseDate(String body, String price) {
    var regText = RegExp("(?<=:[0-9]{2}[ ,\n]).+");
    var text = regText.stringMatch(body);
    if(text == null)
      text = body.replaceAll("[Web발신]", "").replaceAll(price, "");

    return text;
  }

  String _parsePrice(String body) {
    var regPrice = RegExp(r'[0-9,-]+(,?[0-9]+)+원');
    var price = regPrice.stringMatch(body);

    return price;
  }

  // SMS 내용 파싱해서 저장
  void insertSmsContent(List<AssetContent> list) async {
    final db = await database;
    Batch batch = db.batch();

    list.forEach((element) {
      batch.insert("daily_cost", element.toMap());
    });

    batch.commit();
    _costController.getMonthCostContent(DateTime.now());
  }
}
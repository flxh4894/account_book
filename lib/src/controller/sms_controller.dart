import 'package:accountbook/src/controller/cost_controller.dart';
import 'package:accountbook/src/helper/db_helper.dart';
import 'package:accountbook/src/model/asset_content.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms/sms.dart';
import 'package:sqflite/sqflite.dart';

class SmsController extends GetxController{
  final CostController _costController = Get.find<CostController>();
  final platform = const MethodChannel('com.polymorph.account_book/read_sms');

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await DatabaseHelper().database;
    return _database;
  }
  List<AssetContent> smsList = <AssetContent>[];
  RxBool receiveFlag = false.obs;

  @override
  void onInit() {
    _getReceiveFlag();
    getLastSmsDate();
    super.onInit();
  }

  // SMS 자동 수신 Flag 가져오기
  void _getReceiveFlag() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    receiveFlag( prefs.getBool("flag") );
  }

  // SMS 자동 수신 Flag 설정하기
  void setReceiveFlag(bool flag) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("flag", flag);
    receiveFlag( flag );
  }

  // 메세지 받았을 때
  void receiveSms(SmsMessage msg) {
    // 문자를 받겠다고 설정한 경우에만
    if(receiveFlag.value){
      smsList.clear();
      _setSmsMessage(msg);
      insertSmsContent(smsList);
    }
  }

  // 마지막 메세지 가져오기
  void getLastSmsDate() async {
    if(receiveFlag.value){
      final db = await database;
      var list = await db.query("daily_cost", orderBy: "date DESC", limit: 1);
      if(list.length == 0)
        print('데이터가 없습니다.');
      else {
        // 가장 마지막 저장된 가계부 정보의 날짜와 비교해서 뒤의 메모만 가져온다.
        String lastDate = AssetContent.fromJson(list[0]).date;
        SmsQuery query = new SmsQuery();
        var dbList = await query.getAllSms;

        smsList.clear();
        dbList.forEach((element) {
          var date = DateFormat('yyyyMMddHHmm').format(element.date);
          if( int.parse(date) > int.parse(lastDate) ){
            _setSmsMessage(element);
          }
        });

        // insertSmsContent(smsList);
      }
    }
  }

  // SMS 파싱 및 list add
  void _setSmsMessage(SmsMessage msg) {
    var price = _parsePrice(msg.body);
    var timeDate = _parseDate(msg.body);
    // 가격정보가 없거나, 승인이 거절된 내용은 빼버림
    if(price == null
        || msg.body.contains("승인거절")
        || msg.body.contains("인증번호")
        || timeDate == null
    ) {
      return;
    }

    var date = DateFormat('yyyyMMddHHmm').format(msg.date);
    var text = _parseText(msg.body, price);
    price = price.replaceAll(",", "").replaceAll("원", "");

    smsList.add(
        AssetContent(
            date: date,
            title: text,
            price: int.parse(price),
            category: -1, // 카테고리 : 미분류
            assetType: 2, // 지출
            assetId: -1 // 자산 : 미분류
        )
    );
  }

  // 네이티브에서 메세지 모두 가져오기
  void getNativeValue(int day) async {
    String value;
    try {
      SmsQuery query = new SmsQuery();
      String selectedDay = DateFormat('yyyyMMdd').format(
          DateTime.now().subtract(Duration(days: day))) + "0000";

      // query.getAllSms.then((value) {
      //   smsList.clear();
      //   value.forEach((element) {
      //     var date = DateFormat('yyyyMMddHHmm').format(element.date);
      //     if( int.parse(date) >= int.parse(selectedDay) ){
      //       _setSmsMessage(element);
      //     }
      //   });
      //
      //   insertSmsContent(smsList);
      //
      //   Get.back();
      //   Get.snackbar("SMS 가져오기", "${smsList.length}건 가져오기 성공",
      //       snackPosition: SnackPosition.BOTTOM);
      // });

      var list = await query.getAllSms;

      smsList.clear();
      list.forEach((element) {
        var date = DateFormat('yyyyMMddHHmm').format(element.date);
        if( int.parse(date) >= int.parse(selectedDay) ){
          _setSmsMessage(element);
        }
      });


      insertSmsContent(smsList);

      Get.back();
      Get.snackbar("SMS 가져오기", "${smsList.length}건 가져오기 성공",
          snackPosition: SnackPosition.BOTTOM);

    } on PlatformException catch (e) {
      value = '네이티브 에러 : ${e.message}';
    }
  }

  // 네이티브에서 직접 가지고 오는 방법
  // Future<void> getSmsAllMessage(int a) async {
  //   String batteryLevel;
  //   try {
  //     List result = await platform.invokeMethod('getValue');
  //     result.forEach((element) {
  //       print(element);
  //     });
  //
  //   } on PlatformException catch (e) {
  //     batteryLevel = "Failed to get battery level: '${e.message}'.";
  //   }
  // }

  // 본문내용(결제한곳)파싱
  String _parseText(String body, String price) {
    var regText = RegExp("(?<=:[0-9]{2}[ ,\n]).+");
    var text = regText.stringMatch(body);
    if(text == null)
      text = body.replaceAll("[Web발신]", "").replaceAll(price, "");

    return text;
  }

  // 날짜, 시간 파싱
  String _parseDate(String body) {
    var regTime = RegExp("[0-9]{2}:[0-9]{2}");
    var regDate = RegExp("[0-9]{2}/[0-9]{2}");
    var time = regTime.stringMatch(body);
    var date = regDate.stringMatch(body);
    if(time == null || date == null)
      return null;

    return "$time$date";
  }

  // 결제 금액 파싱
  String _parsePrice(String body) {
    var regPrice = RegExp(r'[0-9,-]+(,?[0-9]+)+원');
    var price = regPrice.stringMatch(body);

    return price;
  }

  // SMS 내용 파싱해서 저장
  void insertSmsContent(List<AssetContent> list) async {
    final db = await database;
    Batch batch = db.batch();

    list.forEach((element) async {
      var list = await db.query(
          "daily_cost",
          where: "price = ? and title = ? and date = ?",
          whereArgs: [element.price, element.title, element.date]
      );
      var isExist = list.length;

      if(isExist == 0)
        batch.insert("daily_cost", element.toMap());
    });

    batch.commit();
    _costController.getMonthCostContent(DateTime.now());
  }
}
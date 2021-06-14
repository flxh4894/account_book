import 'package:accountbook/src/controller/cost_controller.dart';
import 'package:accountbook/src/helper/db_helper.dart';
import 'package:accountbook/src/model/asset_content.dart';
import 'package:accountbook/src/model/sms_asset_list.dart';
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
  RxList<SmsAssetList> smsAssetList = <SmsAssetList>[].obs;

  @override
  void onInit() {
    init();
    super.onInit();
  }

  // 초기함수 모음
  void init() async {
    await _getReceiveFlag(); // 메세지 자동수신 Flag 가져오기
    await _selectSmsAssetList(); // 문구별 자동 연동 리스트 가져오기
    _getLastSmsDate(); // 마지막 메세직보다 나중에 온 메세지들 읽어오기
  }

  // SMS 자동 수신 Flag 가져오기
  Future<bool> _getReceiveFlag() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    receiveFlag( prefs.getBool("flag") );

    return true;
  }

  // SMS 자동 수신 Flag 설정하기
  void setReceiveFlag(bool flag) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("flag", flag);
    receiveFlag( flag );
  }

  // 메세지 받았을 때 문자 처리
  void receiveSms(SmsMessage msg) {
    // 문자를 받겠다고 설정한 경우에만
    if(receiveFlag.value){
      smsList.clear();
      _setSmsMessage(msg);
      _insertSmsContent(smsList);
    }
  }

  // 마지막 메세지보다 나중 문자들 가져오기
  Future<bool> _getLastSmsDate() async {
    if(receiveFlag.value){
      final db = await database;
      var list = await db.query("daily_cost", orderBy: "date DESC", limit: 1);
      if(list.length == 0)
        return true;
        // print('데이터가 없습니다.');
      else {
        // 가장 마지막 저장된 가계부 정보의 날짜와 비교해서 뒤의 메모만 가져온다.
        String lastDate = AssetContent.fromJson(list[0]).date;
        SmsQuery query = new SmsQuery();
        var dbList = await query.getAllSms;

        smsList.clear();
        for(SmsMessage element in dbList) {
          var date = DateFormat('yyyyMMddHHmm').format(element.date);
          if( int.parse(date) > int.parse(lastDate) ){
            _setSmsMessage(element);
          }
        }
        _insertSmsContent(smsList);
      }
    }

    return true;
  }

  // SMS 파싱 및 list add
  void _setSmsMessage(SmsMessage msg) {
    var price = _parsePrice(msg.body);
    var timeDate = _parseDate(msg.body);

    // 입력을 안하는 경우 작성
    if(price == null
        || msg.body.contains("승인거절")
        || msg.body.contains("인증번호")
        || msg.body.contains("(광고)")
        || timeDate == null
    ) {
      return;
    }

    /* 데이터 파싱
    * date : 문자를 받은 시간을 기준으로
    * text : 정규식을 써서
    * price : 정규식 + 콤마와 글자 제거 (숫자만 표기되도록)
    * */
    var date = DateFormat('yyyyMMddHHmm').format(msg.date);
    var text = _parseText(msg.body, price);
    price = price.replaceAll(",", "").replaceAll("원", "");

    var assetId = -1;
    for(SmsAssetList asset in smsAssetList){
      if(msg.body.contains(asset.word)){
        assetId = asset.id;
        break;
      }
    }

    smsList.add(
        AssetContent(
            date: date,
            title: text,
            price: int.parse(price),
            category: -1, // 카테고리 : 미분류
            assetType: 2, // 지출
            assetId: assetId // 자산 : 미분류
        )
    );
  }

  // 네이티브에서 메세지 모두 가져오기
  void getNativeValue(int day) async {
    try {
      SmsQuery query = new SmsQuery();
      String selectedDay = DateFormat('yyyyMMdd').format(
          DateTime.now().subtract(Duration(days: day))) + "0000";

      var list = await query.getAllSms;

      smsList.clear();
      list.forEach((element) {
        var date = DateFormat('yyyyMMddHHmm').format(element.date);
        if( int.parse(date) >= int.parse(selectedDay) ){
          _setSmsMessage(element);
        }
      });

      int count = await _insertSmsContent(smsList);
      Get.back();
      Get.snackbar("SMS 가져오기", "$count건 가져오기 성공",
          snackPosition: SnackPosition.TOP);

    } on PlatformException catch (e) {
      Get.back();
      Get.snackbar("SMS 가져오기", "가져오기에 실패하였습니다.",
          snackPosition: SnackPosition.TOP);

    }
  }

  // 본문내용(결제한곳)파싱
  // 결제한 곳 파싱
  String _parseText(String body, String price) {
    var regText = RegExp("(?<=:[0-9]{2}[ ,\n]).+");
    var text = regText.stringMatch(body);
    if(text == null)
      text = body.replaceAll("[Web발신]", "").replaceAll(price, "");
    else { // 정규식으로 자른 내용 추가 파싱 Replace (지속 추가 필요)
      text = text.replaceAll("(금액)", "").replaceAll(price, "").replaceAll(" ", "");
    }
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
  Future<int> _insertSmsContent(List<AssetContent> list) async {
    final db = await database;
    Batch batch = db.batch();
    int count = 0;

    for(AssetContent element in list) {
      var list = await db.query(
          "daily_cost",
          where: "price = ? and title = ? and date = ?",
          whereArgs: [element.price, element.title, element.date]
      );

      if(list.length == 0) { // 테이블에 해당 데이터가 없는 경우에 Insert
        batch.insert("daily_cost", element.toMap());
        count ++;
      }
    }

    /* 커밋 후 다시 불러옴 */
    batch.commit();
    _costController.getMonthCostContent(DateTime.now());

    return count;
  }

  // SMS 문구별 자산 연동 리스트 가져오기
  Future<bool> _selectSmsAssetList() async {
    final db = await database;

    var list = await db.rawQuery(
      "SELECT "
          "A.id AS id, "
          "A.name AS card_nm, "
          "A.memo AS card_tag, "
          "B.word AS word "
      "FROM "
          "assets A, sms_asset_matcher B "
      "WHERE "
          "A.id = B.asset_id"
    );

    smsAssetList( list.map((e) => SmsAssetList.fromJson(e)).toList() );
    return true;
  }

  // SMS 문구별 자산 연동 삽입
  void insertSmsAssetList(String word, int assetId) async {
    final db = await database;
    await db.insert("sms_asset_matcher", {"word": word, "asset_id": assetId});
    _selectSmsAssetList(); // 리로드
  }

  // SMS 문구별 자산 연동 삭제
  void deleteSmsAssetList(List<int> list) async {
    final db = await database;
    Batch batch = db.batch();

    list.forEach((element) {
      batch.delete("sms_asset_matcher", where: "id = ?", whereArgs: [element]);
    });
    batch.commit();
    _selectSmsAssetList();

    Get.back();
  }
}
import 'package:accountbook/src/helper/db_helper.dart';
import 'package:accountbook/src/model/asset_info.dart';
import 'package:accountbook/src/model/credit_card.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

class CardController extends GetxController {
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await DatabaseHelper().database;
    return _database;
  }
  RxList<CreditCard> cardList = <CreditCard>[].obs; // 추가된 카드리스트
  RxList<AssetInfo> addableCardList = <AssetInfo>[].obs; // 추가가능한 카드리스트
  RxInt okay = 0.obs; // 실적 충족 수
  RxInt yet = 0.obs; // 실적 미충족 수

  @override
  void onInit() {
    getCreditCardList();
    super.onInit();
  }

  // 추가된 카드 리스트 불러오기
  void getCreditCardList() async {
    final db = await database;

    DateTime date = DateTime.now();
    final year = date.year;
    final month = date.month < 10 ? '0${date.month}' : date.month;
    final yearMonth = '$year$month';

    // ** 초기화
    cardList.clear(); // 카드리스트
    okay(0); // 달성
    yet(0); // 미달성
    var list = await db.query("credit_card");

    list.forEach((element) async {
      var dbPrice = await db.rawQuery(
        "SELECT SUM(price) AS price "
        "FROM daily_cost "
        "WHERE asset_id = ${element['asset_id']} "
        "AND date BETWEEN '${yearMonth}01' AND '${yearMonth}31'"
      );
      int price = dbPrice[0]['price'];

      cardList.add(
        new CreditCard(
          id: element['id'],
          assetId: element['asset_id'],
          price: price == null ? 0 : price,
          tag: element['tag'],
          cardNm: element['card_nm'],
          performance: element['performance'],
          payDate: element['pay_date']
        )
      );

      if(price == null)
        yet(yet.value + 1);
      else
        price >= element['performance'] ? okay(okay.value + 1) : yet(yet.value + 1);
    });

  }

  // 추가가능한 카드 리스트 불러오기
  void getAddableCardList() async {
    final db = await database;
    var list = await db.rawQuery(""
        "SELECT A.id, A.name, A.memo "
        "FROM assets A LEFT JOIN credit_card B ON B.asset_id = A.id "
        "WHERE B.asset_id IS NULL AND A.type = 3");

    addableCardList( list.map((e) => AssetInfo.fromJson(e)).toList() );
    list.forEach((element) {
      print(element);
    });

  }
  
  // 카드리스트 추가
  void insertCardInfo(CreditCard creditCard) async {
    final db = await database;
    await db.insert("credit_card", creditCard.toMap());
    getCreditCardList();
  } 
 }
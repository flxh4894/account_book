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
    getAddableCardList();
    super.onInit();
  }

  // 추가된 카드 리스트 불러오기
  void getCreditCardList() async {
    final db = await database;
    var list = await db.rawQuery(
        "SELECT A.*, sum(B.price) as price "
        "FROM credit_card A, daily_cost B "
        "WHERE A.asset_id = B.asset_id GROUP BY B.asset_id ORDER BY price ASC"
    );
    cardList( list.map((e) => CreditCard.fromJson(e)).toList() );

    okay(0);
    yet(0);
    cardList.forEach((element) {
      element.price >= element.performance ? okay(okay.value + 1) :
      yet(yet.value + 1);
    });
  }

  // 추가가능한 카드 리스트 불러오기
  void getAddableCardList() async {
    final db = await database;
    var list = await db.rawQuery(""
        "SELECT A.id, A.name, A.memo "
        "FROM assets A LEFT JOIN credit_card B ON B.asset_id = A.id "
        "WHERE B.asset_id IS NULL AND A.type = 2");

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
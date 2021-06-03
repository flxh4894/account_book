import 'package:accountbook/src/component/dialog/add_card_dialog.dart';
import 'package:accountbook/src/controller/card_controller.dart';
import 'package:accountbook/src/model/credit_card.dart';
import 'package:accountbook/src/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardPerformancePage extends StatefulWidget {
  @override
  _CardPerformancePageState createState() => _CardPerformancePageState();
}

class _CardPerformancePageState extends State<CardPerformancePage> {
  final CommonUtils _utils = CommonUtils();
  final CardController _cardController = Get.find<CardController>();

  @override
  void initState() {
    _cardController.getCreditCardList();
    super.initState();
  }

  Widget _appbar() {
    return AppBar(
      title: Text('카드 실적'),
      elevation: 0,
      backgroundColor: Colors.white,
      actions: [
        GestureDetector(
          onTap: () {
            _cardController.getAddableCardList();
            showDialog(
                context: context,
                builder: (context) {
                  return AddCardDialog();
                }
            );
          },
          child: Row(
            children: [
              Image.asset(
                "assets/icons/credit_card.png",
                width: 40,
                height: 40,
              ),
              Text('카드추가'),
              SizedBox(width: 20)
            ],
          ),
        )
      ],
    );
  }

  Widget _body() {
    return _cardList();
  }

  Widget _cardList() {
    return Container(
      child: Obx(
        () => Column(
          children: [
            _cardInfo(),
            SizedBox(height: 10),
            Expanded(
              child: _cardController.cardList.length == 0 ? _noCardList() :
              ListView.builder(
                itemCount: _cardController.cardList.length,
                itemBuilder: (context, index) {
                  CreditCard cardInfo = _cardController.cardList[index];
                  var name = cardInfo.cardNm;
                  var price = cardInfo.price;
                  var performance = cardInfo.performance;
                  var assetId = cardInfo.assetId;
                  var payDate = cardInfo.payDate;
                  var memo = cardInfo.tag;

                  return _cardTile(name, memo, price, performance, assetId, payDate);
                }
              ),
            ),
          ]
        ),
      ),
    );
  }

  Widget _cardInfo() {
    return Stack(
      alignment: Alignment.topCenter,
        children:
          [
            Image.asset("assets/images/credit_bg.png"),
            Positioned(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('달성 ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('${_cardController.okay}개', style: TextStyle(fontSize: 18, color: Colors.red, fontWeight: FontWeight.bold)),
                        SizedBox(width: 20),
                        Text('미달성 ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('${_cardController.yet}개', style: TextStyle(fontSize: 18, color: Colors.blue, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text('※ 1일부터 말일까지 카드 사용 내역')
                    
                  ],
                )
              ),
            ),
          ]
      );
  }

  Widget _cardTile(String title, String memo, int money, int performance, int assetId, int payDate) {
    return Container(
      margin: EdgeInsets.only(bottom: 10, left: 16, right: 16),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 1.0,
            spreadRadius: 1.0,
            offset: Offset(2.0, 2.0), // shadow direction: bottom right
          )
        ],
      ),
      height: 90,
      child: Row(
        children: [
          money >= performance ? Icon(Icons.check_circle_outline_outlined, color: Colors.green)
          : Icon(Icons.cancel_outlined, color: Colors.red),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: TextStyle(fontSize: 16)),
                Text('#$memo', style: TextStyle(fontSize: 14, color: Colors.black.withOpacity(0.5))),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_utils.priceFormat(money),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: money >= performance ? Colors.red : Colors.blue)
              ),
              Text('실적: ${_utils.priceFormat(300000)}',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.black.withOpacity(0.5))
              ),
              Text('결제일: $payDate 일',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.black.withOpacity(0.5))
              ),
            ]
          ),
        ],
      ),
    );
  }

  Widget _noCardList() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('마이페이지 > 은행 및 카드관리에서 카드를 등록해 주세요.'),
        GestureDetector(
          onTap: () {
            _cardController.getAddableCardList();
            showDialog(
                context: context,
                builder: (context) {
                  return AddCardDialog();
                }
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/icons/credit_card.png",
                width: 100,
                height: 100,
              ),
              Text('추가하기', style: TextStyle(fontSize: 30)),
              SizedBox(width: 20)
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(),
      body: _body(),
    );
  }
}

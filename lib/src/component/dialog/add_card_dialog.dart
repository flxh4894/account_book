import 'package:accountbook/src/controller/asset_controller.dart';
import 'package:accountbook/src/controller/card_controller.dart';
import 'package:accountbook/src/model/asset_info.dart';
import 'package:accountbook/src/model/credit_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// 실적확인 카드 추가
class AddCardDialog extends StatefulWidget {
  @override
  _AddCardDialogState createState() => _AddCardDialogState();
}

class _AddCardDialogState extends State<AddCardDialog> {
  final CardController _cardController = Get.find<CardController>();
  final TextEditingController _textName = TextEditingController();
  final TextEditingController _textTag = TextEditingController();
  final TextEditingController _textPerformance = TextEditingController();
  final TextEditingController _textDate = TextEditingController();

  String selected;
  int assetId = -1;

  @override
  void initState() {
    setState(() {
      if(_cardController.addableCardList.length > 0){
        selected = _cardController.addableCardList[0].name;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 1,
        backgroundColor: Colors.white,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: Theme.of(context).primaryColor,
                ),
                child: Center(
                    child: Text('카드 추가',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)
                    )
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Text('이름'),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              style: TextStyle(fontSize: 14),
                              decoration: InputDecoration(
                                isDense: true,
                                hintText: 'ex) 삼성카드',
                                contentPadding: EdgeInsets.all(10),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide:
                                  BorderSide(color: Colors.black.withOpacity(0.3)),
                                ),
                              ),
                              controller: _textName,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text('태그'),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              style: TextStyle(fontSize: 14),
                              decoration: InputDecoration(
                                hintText: 'ex) 커피숍 월 5,000원 할인',
                                isDense: true,
                                contentPadding: EdgeInsets.all(10),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide:
                                  BorderSide(color: Colors.black.withOpacity(0.3)),
                                ),
                              ),
                              controller: _textTag,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text('카드선택'),
                          SizedBox(width: 20),
                          Expanded(
                            child: _cardController.addableCardList.length > 0 ?
                            DropdownButton(
                              isExpanded: true,
                              elevation: 1,
                              value: selected,
                              items: _cardController.addableCardList.map((e) =>
                                  DropdownMenuItem(
                                    value: e.name,
                                    onTap: () {
                                      setState(() {
                                        assetId = e.id;
                                        selected = e.name;
                                      });
                                    },
                                    child: Text(e.name, style: TextStyle(fontSize: 14))
                                  )
                              ).toList(),
                              onChanged: (newValue) {},
                            ) :
                            Text('등록 가능한 카드가 없습니다.')
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text('실적'),
                          SizedBox(width: 20),
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              style: TextStyle(fontSize: 14),
                              decoration: InputDecoration(
                                hintText: 'ex) 300,000원',
                                isDense: true,
                                contentPadding: EdgeInsets.all(10),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide:
                                  BorderSide(color: Colors.black.withOpacity(0.3)),
                                ),
                              ),
                              controller: _textPerformance,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text('결제일'),
                          SizedBox(width: 20),
                          Expanded(
                            child: TextFormField(
                              style: TextStyle(fontSize: 14),
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'ex) 14일',
                                isDense: true,
                                contentPadding: EdgeInsets.all(10),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide:
                                  BorderSide(color: Colors.black.withOpacity(0.3)),
                                ),
                              ),
                              controller: _textDate,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(onPressed: () {
                    CreditCard card = new CreditCard(
                        assetId: assetId,
                        payDate: int.parse(_textDate.text),
                        performance: int.parse(_textPerformance.text),
                        price: 0,
                        tag: _textTag.text,
                        cardNm: _textName.text
                    );

                    _cardController.insertCardInfo(card);
                    Get.back();
                  }, child: Text('추가')),
                  TextButton(onPressed: () => Get.back(), child: Text('취소')),
                ],
              )
            ],
          ),
        )
    );
  }
}

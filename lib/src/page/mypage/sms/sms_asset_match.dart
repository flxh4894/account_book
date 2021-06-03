import 'package:accountbook/src/component/dialog/sms_asset_match_dialog.dart';
import 'package:flutter/material.dart';

class SmsAssetMatchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: _body(context),
    );
  }

  Column _body(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: Theme.of(context).primaryColor,
          child: Text('해당 문구가 포함된 SMS는\n해당 자산으로 설정됩니다.',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        _rowTile('삼성(1234) 이*원', "삼성카드", "#탭탭오"),
        _rowTile('국민(0102) 이*원', "국민카드", "#나라사랑카드"),
        _rowTile('삼성(5612) 이*원', "삼성카드", "#더파이브"),
        _rowTile('신한(1022) 이*원', "신한카드", "#네이버페이"),
      ],
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: Text('문구별 자산 연동'),
      elevation: 0,
      backgroundColor: Colors.white,
      actions: [
        TextButton(onPressed: (){
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return SmsAssetMatchDialog();
              }
          );
        }, child: Text('추가하기')),
      ],

    );
  }

  Widget _rowTile(String text, String card, String tag) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
      margin: EdgeInsets.symmetric(horizontal: 16,vertical: 5),
      height: 60,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$text'),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('$card'),
              Text(tag, style: TextStyle(
                color: Colors.black.withOpacity(0.5),
                fontSize: 14
              ))
            ],
          )
        ],
      ),
    );
  }
}

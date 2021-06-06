import 'package:accountbook/src/component/dialog/sms_asset_match_dialog.dart';
import 'package:accountbook/src/controller/sms_controller.dart';
import 'package:accountbook/src/page/mypage/sms/sms_asset_match_edit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IgnoreSmsListPage extends StatelessWidget {
  final SmsController _smsController = Get.find<SmsController>();

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
            child: Row(
              children: [
                Text('등록한 번호는 SMS 연동에서 제외됩니다.',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () => Get.dialog(
                            alertDialog(context)
                        ),
                        icon: Icon(Icons.help_outline_outlined, color: Colors.white),
                      ),
                    )
                )
              ],
            )
        ),
        Obx(
              () => Expanded(
            child: ListView.builder(
                itemCount: _smsController.smsAssetList.length,
                itemBuilder: (context, index) {
                  return _rowTile(_smsController.smsAssetList[index].id,
                      _smsController.smsAssetList[index].word,
                      _smsController.smsAssetList[index].cardNm,
                      _smsController.smsAssetList[index].cardTag,
                      context
                  );
                }),
          ),
        ),
      ],
    );
  }

  AlertDialog alertDialog(BuildContext context) {
    return AlertDialog(
        elevation: 1,
        titlePadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
        ),
        title: Container(
          height: 50,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Center(child: Text('문구별 자산 연동이란?', style: TextStyle(color: Colors.white))),
        ),
        content: Container(
          height: 480,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Image.asset("assets/images/sms_info.png")
              ),
              SizedBox(height: 10),
              Container(
                  child: Text('반복되는 문구를 등록하여\n해당 문구가 포함된 SMS를\n선택한 카드로 입력되게 합니다.', style: TextStyle(fontSize: 18, height: 1.5),)
              ),
              SizedBox(height: 10),
              TextButton(
                child: Text('확인'),
                onPressed: () => Get.back(),
              ),
            ],
          ),
        )
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: Text('연동 제외 번호 설정'),
      elevation: 0,
      backgroundColor: Colors.white,
      actions: [
        PopupMenuButton(
          icon: Icon(Icons.more_horiz),
          itemBuilder: (context) => [
            PopupMenuItem(
                value: 0,
                child: Text('추가하기')
            ),
            PopupMenuItem(
                value: 1,
                child: Text('삭제하기')
            ),
          ],
          onSelected: (item) {
            _menuActions(item);
          },
        )
        // TextButton(onPressed: (){
        //   showDialog(
        //       barrierDismissible: false,
        //       context: context,
        //       builder: (context) {
        //         return SmsAssetMatchDialog();
        //       }
        //   );
        // }, child: Text('추가하기')),
      ],
    );
  }

  void _menuActions(int item) {
    switch(item){
      case 0:
        Get.dialog(SmsAssetMatchDialog());
        break;
      case 1:
        Get.to(() => SmsAssetMatchEditPage(), transition: Transition.noTransition);
        break;
    }
  }

  Widget _rowTile(int id, String text, String card, String tag, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16,vertical: 5),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onLongPress: () => Get.to(
                  () => SmsAssetMatchEditPage(),
              transition: Transition.noTransition,
              arguments: id),
          splashColor: Colors.transparent,
          highlightColor: Theme.of(context).primaryColor.withOpacity(0.5),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$text'),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
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
          ),
        ),
      ),
    );
  }
}

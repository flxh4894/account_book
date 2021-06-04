import 'package:accountbook/src/component/dialog/sms_asset_match_dialog.dart';
import 'package:accountbook/src/controller/sms_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SmsAssetMatchEditPage extends StatefulWidget {
  @override
  _SmsAssetMatchEditPageState createState() => _SmsAssetMatchEditPageState();
}

class _SmsAssetMatchEditPageState extends State<SmsAssetMatchEditPage> {
  final SmsController _smsController = Get.find<SmsController>();

  List<int> _selected = [];

  @override
  void initState() {
    if(Get.arguments != null)
      _selected.add(Get.arguments);
    super.initState();
  }

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
          child: Text('${_selected.length}건이 선택 되었습니다.',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
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

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: Text('문구별 자산 연동'),
      elevation: 0,
      backgroundColor: Colors.white,
      actions: [
        IconButton(
          onPressed: (){
            Get.dialog(
              AlertDialog(
                elevation: 1,
                titlePadding: EdgeInsets.zero,
                contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                title: Container(
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                    ),
                  ),

                  child: Center(child: Text('${_selected.length}건을 삭제 합니다.', style: TextStyle(color: Colors.white))),
                ),
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        child: Text('취소'),
                        onPressed: () => Get.back(),
                      ),
                      SizedBox(width: 5,),
                      TextButton(
                        child: Text('삭제', style: TextStyle(color: Colors.red)),
                        onPressed: () {
                          _smsController.deleteSmsAssetList(_selected);
                          Get.back();
                        }
                      ),
                    ],
                  )
              )
            );
          },
          icon: Icon(Icons.delete_outlined)
        )
      ],

    );
  }

  Widget _rowTile(int id, String text, String card, String tag, BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if(!_selected.contains(id))
            _selected.add(id);
          else {
            var index = _selected.indexOf(id);
            _selected.removeAt(index);
          }
        });
        if(_selected.length == 0)
          Get.back();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
        margin: EdgeInsets.symmetric(horizontal: 16,vertical: 5),
        height: 60,
        decoration: BoxDecoration(
          color: _selected.contains(id) ? Theme.of(context).primaryColor.withOpacity(0.5) : Colors.white,
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
    );
  }
}

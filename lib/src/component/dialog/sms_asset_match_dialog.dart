import 'package:accountbook/src/controller/asset_controller.dart';
import 'package:accountbook/src/controller/sms_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'add_asset_dialog.dart';

class SmsAssetMatchDialog extends StatefulWidget {
  @override
  _SmsAssetMatchDialogState createState() => _SmsAssetMatchDialogState();
}

class _SmsAssetMatchDialogState extends State<SmsAssetMatchDialog> {

  final TextEditingController _text = TextEditingController();
  final AssetController _assetController = Get.put(AssetController());
  final SmsController _smsController = Get.find<SmsController>();

  String selected;
  int assetId = -1;

  @override
  void initState() {
    setState(() {
      if(_assetController.assetInfoList.length > 0){
        selected = _assetController.assetInfoList[0].name;
        assetId = _assetController.assetInfoList[0].id;
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
          height: MediaQuery
              .of(context)
              .size
              .height * 0.35,
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
                  color: Theme
                      .of(context)
                      .primaryColor,
                ),
                child: Center(
                    child: Text('문구별 자산 연동',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)
                    )
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Text('문구 : ', style: TextStyle(fontSize: 16)),
                          Expanded(
                            child: TextFormField(
                              style: TextStyle(
                                fontSize: 16
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                hintText: 'ex) OO카드(1234) 홍*동',
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide:
                                  BorderSide(color: Colors.black.withOpacity(0.3)),
                                ),
                              ),
                              maxLines: 1,
                              controller: _text,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text('자산 : ', style: TextStyle(fontSize: 16)),
                          Expanded(
                            child: Obx(
                              () => _assetController.assetInfoList.length == 0 ?
                              Text('마이페이지 ➡ \n은행 및 카드관리 에서 자산을 등록해 주세요.') :
                              DropdownButton(
                                isExpanded: true,
                                elevation: 1,
                                value: selected,
                                items: _assetController.assetInfoList.map((e) =>
                                    DropdownMenuItem(
                                        value: e.name,
                                        onTap: () {
                                          setState(() {
                                            assetId = e.id;
                                            selected = e.name;
                                          });
                                        },
                                        child: Text('${e.name} #${e.memo}', style: TextStyle(fontSize: 16))
                                    )
                                ).toList(),
                                onChanged: (newValue) {},
                              ),
                            )
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text('취소', style: TextStyle(color: Colors.black))
                  ),
                  GestureDetector(
                    onTap: () {
                      _smsController.insertSmsAssetList(_text.text, assetId);
                      Get.back();
                    },
                    child: Row(
                      children: [
                        Text('추가', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        )
    );
  }
}

import 'package:accountbook/src/controller/asset_controller.dart';
import 'package:accountbook/src/model/asset_info.dart';
import 'package:accountbook/src/model/daily_cost.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// 자산추가 다이어로그
class AddBaseAssetDialog extends StatefulWidget {
  final int assetType;
  AddBaseAssetDialog({this.assetType});

  @override
  _AddBaseAssetDialogState createState() => _AddBaseAssetDialogState();
}

class _AddBaseAssetDialogState extends State<AddBaseAssetDialog> {
  final AssetController _assetController = Get.find<AssetController>();

  final TextEditingController _textPrice = TextEditingController();
  final _assetTypeList = ['현금', '은행(통장)', '', '투자', '대출', '기타'];
  String _assetType;
  String _assetNm;
  int _assetId = -1;


  @override
  void initState() {
    _assetType = _assetTypeList[widget.assetType - 1];
    _assetController.selectBaseAssetList(widget.assetType);
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
          height: 350,
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
                    child: Text('나의 자산 추가',
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
                          Text('구분'),
                          SizedBox(width: 20),
                          Expanded(
                            child: TextFormField(
                              readOnly: true,
                              style: TextStyle(fontSize: 14),
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide:
                                  BorderSide(color: Colors.black.withOpacity(0.3)),
                                ),
                              ),
                              initialValue: _assetType,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text('자산'),
                          SizedBox(width: 20),
                          Expanded(
                            child: Obx(
                              () {
                                var asset = _assetController.baseAssetList;
                                if(asset.length != 0){
                                  _assetNm = _assetController.baseAssetList[0].name;
                                  _assetId = _assetController.baseAssetList[0].id;
                                }
                                return DropdownButton(
                                  isExpanded: true,
                                  elevation: 1,
                                  value: _assetNm,
                                  items: _assetController.baseAssetList.map((
                                      e) {
                                    return DropdownMenuItem(
                                        value: e.name,
                                        onTap: () {
                                          setState(() {
                                            _assetId = e.id;
                                          });
                                        },
                                        child: Text('${e.name} #${e.memo}',
                                            style: TextStyle(fontSize: 14))
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _assetNm = value;
                                    });
                                  },
                                );
                              }),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text('금액'),
                          SizedBox(width: 20),
                          Expanded(
                            child: TextFormField(
                              style: TextStyle(fontSize: 14),
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                isDense: true,
                                hintText: 'ex) 50,000,000 원',
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
                              controller: _textPrice,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(onPressed: () {

                    if(_assetId == -1){
                      Get.defaultDialog(
                          barrierDismissible: true,
                          title: '',
                          textCancel: '확인',
                          content: Center(
                            child: Text('자산을 선택해 주세요.'),
                          )
                      );
                      return;
                    }

                    if(_textPrice.text == ""){
                      Get.defaultDialog(
                          barrierDismissible: true,
                          title: '',
                          textCancel: '확인',
                          content: Center(
                            child: Text('금액을 입력해 주세요.'),
                          )
                      );
                      return;
                    }

                    DailyCost dailyCost = new DailyCost(
                      price: int.parse(_textPrice.text),
                      assetId: _assetId,
                      categoryId: -1,
                      type: 1,
                      date: '000000000000',
                      title: '초기자본'
                    );
                    _assetController.insertBaseAssetInfo(dailyCost);
                    Get.back();
                  }, child: Text('추가', style: TextStyle(color: Colors.blue)) ),
                  TextButton(onPressed: () => Get.back(), child: Text('취소')),
                ],
              )
            ],
          ),
        )
    );
  }
}

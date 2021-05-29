import 'package:accountbook/src/controller/asset_controller.dart';
import 'package:accountbook/src/model/asset_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// 기존 자산 추가 등록 다이얼로그 (투자, 은행, 현금 등 만 리스트 업)
class AddAssetDialog extends StatefulWidget {
  @override
  _AddAssetDialogState createState() => _AddAssetDialogState();
}

class _AddAssetDialogState extends State<AddAssetDialog> {
  final AssetController _assetController = Get.find<AssetController>();

  final TextEditingController _textName = TextEditingController();
  final TextEditingController _textTag = TextEditingController();
  final _assetTypeList = ['현금', '저축', '투자', '대출', '보험', '기타'];
  String _assetType = '현금'; // 기본값 : 현금
  int _isFavorite = 0; // 즐겨찾기 설정 기본값 : false

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
                    child: Text('자산추가',
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
                                hintText: 'ex) taptap O',
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
                          Text('분류'),
                          SizedBox(width: 20),
                          Expanded(
                            child: DropdownButton(
                              isExpanded: true,
                              elevation: 1,
                              value: _assetType,
                              items: _assetTypeList.map((e) =>
                                  DropdownMenuItem(
                                    value: e,
                                    child: Text(e, style: TextStyle(fontSize: 14))
                                  )
                              ).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  _assetType = newValue;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text('즐겨찾기 설정'),
                          IconButton(icon: _isFavorite == 1 ?
                            Icon(Icons.favorite, color: Colors.pinkAccent)
                            : Icon(Icons.favorite_border_outlined, color: Colors.grey.withOpacity(0.5)),
                              onPressed: (){
                                setState(() {
                                  if(_isFavorite == 0)
                                    _isFavorite = 1;
                                  else
                                    _isFavorite = 0;
                                });
                              })
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
                    _assetController.insertAssetInfo(new AssetInfo(
                      isFavorite: _isFavorite,
                      name: _textName.text,
                      memo: _textTag.text,
                      type: _assetTypeList.indexOf(_assetType) + 1
                    ));
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

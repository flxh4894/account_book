import 'package:accountbook/src/controller/asset_controller.dart';
import 'package:accountbook/src/model/asset_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AssetManagementEditPage extends StatefulWidget {
  @override
  _AssetManagementEditPageState createState() => _AssetManagementEditPageState();
}

class _AssetManagementEditPageState extends State<AssetManagementEditPage> {
  final AssetController _assetController = Get.find<AssetController>();
  final AssetInfo content = Get.arguments;
  final TextEditingController _textName = TextEditingController();
  final TextEditingController _textTag = TextEditingController();
  final _assetTypeList = ['현금', '은행(통장)', '신용(체크)카드', '투자', '기타'];
  String _assetType = '현금';
  int _isFavorite = 0;


  @override
  void initState() {
    _textName.text = content.name;
    _textTag.text = content.memo;
    _assetType = _assetTypeList[content.type - 1];
    _isFavorite = content.isFavorite;

    _assetController.selectAssetInDailyCost(content.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appbar(),
      body: _body(context),
    );
  }

  Container _body(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _deleteInfo(context),
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
                _assetController.updateAssetInfo(new AssetInfo(
                    id: content.id,
                    isFavorite: _isFavorite,
                    name: _textName.text,
                    memo: _textTag.text,
                    type: _assetTypeList.indexOf(_assetType) + 1
                ));
                Get.back();
              }, child: Text('수정', style: TextStyle(color: Colors.blue)) ),
              TextButton(onPressed: () => Get.back(), child: Text('취소')),
            ],
          )
        ],
      ),
    );
  }

  Widget _deleteInfo(BuildContext context) {
    return Obx(
      () => _assetController.deleteFlag.value == true ?
      Container() :
      Container(
        color: Theme.of(context).primaryColor,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Text('해당 자산으로 입력된 가계부가 존재해서'
            '\n삭제는 불가능 합니다.', style: TextStyle(color: Colors.white)),
      )
    );
  }

  AppBar _appbar() {
    return AppBar(
      title: Text('${content.name} 수정'),
      elevation: 0,
      backgroundColor: Colors.white,
      actions: [
        Obx(
          () => _assetController.deleteFlag.value ?
          IconButton(
              onPressed: () {
                Get.dialog(
                    alertDialog()
                );
              },
              icon: Icon(Icons.delete_outlined)
          ):
          Container()
        )
      ],
    );
  }

  AlertDialog alertDialog() {
    return AlertDialog(
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

          child: Center(child: Text('삭제 할까요?', style: TextStyle(color: Colors.white))),
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
                  _assetController.deleteAssetInfo(content.id);
                  Get.back();
                }
            ),
          ],
        )
    );
  }
}

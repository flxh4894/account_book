import 'package:accountbook/src/component/dialog/base_asset_dialog.dart';
import 'package:accountbook/src/controller/asset_controller.dart';
import 'package:accountbook/src/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyAssetsPage extends StatefulWidget {
  @override
  _MyAssetsPageState createState() => _MyAssetsPageState();
}

class _MyAssetsPageState extends State<MyAssetsPage> {
  final AssetController _assetController = Get.put(AssetController());
  final CommonUtils _utils = CommonUtils();

  Widget _rowTile(String title, Widget widget, int type) {
    String price = _assetController.baseAssetSumList[type] == null ?
    _utils.priceFormat(0) :
    _utils.priceFormat(_assetController.baseAssetSumList[type]);
    widget = widget == null ? Container() : widget;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(width:15),
                  _addAssetBtn(type)
                ],
              ),
              Text("$price", style: TextStyle(color: Colors.red))
            ],
          ),
          SizedBox(height: 10),
          _assetRowTile(type)
        ],
      ),
    );
  }

  Widget _assetRowTile(int type) {
    return FutureBuilder(
      future: _assetController.selectAssetTypeList(type),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if(snapshot.data != null){
          return Container(
            child: Column(
              children: [
                for(var asset in snapshot.data)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('- ${asset['name']} #${asset['tag']}'),
                      Text("${_utils.priceFormat(asset['price'])}")
                    ],
                  )
              ],
            ),
          );
        } else {
          return Container();
        }
      }
    );

  }

  Widget _body() {
    return SingleChildScrollView(
      child: Obx(
        () => Column(
          children: [
            _rowTile('현금', null, 1),
            _rowTile('은행', null, 2),
            _rowTile('투자', null, 4),
            _rowTile('대출', null, 5),
            _rowTile('기타', null, 6),
          ],
        ),
      ),
    );
  }

  Widget _addAssetBtn(int type) {
    return GestureDetector(
      onTap: () {
        Get.dialog(
          AddBaseAssetDialog(assetType: type)
        );
      },
      child: Icon(Icons.add, color: Colors.red,)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(context),
      body: _body(),
    );
  }

  AppBar _appbar(BuildContext context) {
    return AppBar(
      title: Text('나의 자산'),
      elevation: 0,
      backgroundColor: Colors.white,
    );
  }
}

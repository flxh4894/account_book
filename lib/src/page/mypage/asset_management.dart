import 'package:accountbook/src/component/dialog/add_asset_dialog.dart';
import 'package:accountbook/src/controller/asset_controller.dart';
import 'package:accountbook/src/page/mypage/asset_management_edit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AssetManagementPage extends StatelessWidget {
  final AssetController _assetController = Get.put(AssetController());

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appbar(context),
      body: Obx(() => _body(context)),
      bottomNavigationBar: GestureDetector(
        onTap: () {
          Get.dialog(AddAssetDialog());
        },
        child: Container(
          height: 50,
          color: Theme.of(context).primaryColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(' 자산추가', style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)
              ),
            ],
          )
        ),
      ),
    );
  }

  Container _body(BuildContext context) {
    var list = _assetController.assetInfoList;
    return Container(
      child: ListView.separated(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return _listRow(index, context);
        },
        separatorBuilder: (context, _) {
          return Divider();
        },
      )
    );
  }

  Widget _listRow(int index, BuildContext context) {
    var content = _assetController.assetInfoList[index];
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Theme.of(context).primaryColor.withOpacity(0.5),
      onTap: () => Get.to(() => AssetManagementEditPage(),
        arguments: content
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${content.name}'),
                SizedBox(height: 5),
                Text('#${content.memo}',
                    style: TextStyle(fontSize: 14,
                        color: Colors.black
                            .withOpacity(0.5))),
              ],
            ),
            IconButton(icon: content.isFavorite == 1
                ? Icon(Icons.favorite, color: Colors.pinkAccent)
                : Icon(Icons.favorite_border_outlined,
                color: Colors.grey.withOpacity(0.5)),
                onPressed: () {
                  if(content.isFavorite == 1)
                    _assetController.updateFavorite(0, _assetController.assetInfoList[index].id);
                  else
                    _assetController.updateFavorite(1, _assetController.assetInfoList[index].id);
                })
          ],
        )
      ),
    );
  }

  AppBar _appbar(BuildContext context) {
    return AppBar(
      title: Text('은행 및 카드관리'),
      elevation: 0,
      backgroundColor: Colors.white,
    );
  }
}

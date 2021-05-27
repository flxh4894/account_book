import 'package:accountbook/src/controller/asset_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'add_asset_dialog.dart';

class AssetDialog extends StatelessWidget {
  final Function callback;

  AssetDialog({this.callback});

  final AssetController _assetController = Get.put(AssetController());


  Widget _listView() {
    var list = _assetController.assetInfoList;
    return ListView.separated(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            callback(list[index].name, list[index].id);
            // _assetController.assetId(
            //     _assetController.assetInfoList[index].id);
            // _assetController.assetNm(
            //     _assetController.assetInfoList[index]
            //         .name);
            Get.back();
          },
          child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: 10, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment
                        .start,
                    children: [
                      Text('${_assetController
                          .assetInfoList[index].name}'),
                      Text('#${_assetController
                          .assetInfoList[index].memo}',
                          style: TextStyle(fontSize: 14,
                              color: Colors.black
                                  .withOpacity(0.5))),
                    ],
                  ),
                  IconButton(icon: _assetController
                      .assetInfoList[index].isFavorite == 1
                      ? Icon(Icons.favorite, color: Colors.pinkAccent)
                      : Icon(Icons.favorite_border_outlined,
                      color: Colors.grey.withOpacity(0.5)),
                      onPressed: () {
                        if(_assetController.assetInfoList[index].isFavorite == 1)
                          _assetController.updateFavorite(0, _assetController.assetInfoList[index].id);
                        else
                          _assetController.updateFavorite(1, _assetController.assetInfoList[index].id);
                      })
                ],
              )
          ),
        );
      },
      separatorBuilder: (context, _) {
        return Divider();
      },
    );
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
              .height * 0.7,
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
                    child: Text('자산',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)
                    )
                ),
              ),
              Expanded(
                  child: Container(
                    padding: EdgeInsets.only(top: 5),
                    child: Obx(
                          () =>
                          _listView()
                    ),
                  )
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(onPressed: () {
                    Get.delete<AssetController>();
                    Get.back();
                  }, child: Text('취소')),
                  GestureDetector(
                    onTap: () =>
                        showDialog(
                            context: context,
                            barrierColor: Colors.transparent,
                            builder: (context) {
                              return AddAssetDialog();
                            }),
                    child: Row(
                      children: [
                        Image.asset("assets/icons/asset_icon.png", width: 25,
                          height: 25,),
                        Text(' 자산추가', style: TextStyle(color: Theme
                            .of(context)
                            .primaryColor))
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

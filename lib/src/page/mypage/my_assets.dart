import 'package:accountbook/src/component/dialog/asset_dialog.dart';
import 'package:flutter/material.dart';

class MyAssetsPage extends StatefulWidget {

  @override
  _MyAssetsPageState createState() => _MyAssetsPageState();
}

class _MyAssetsPageState extends State<MyAssetsPage> {
  Widget _rowTile(String title, Widget widget) {
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
                  _addAssetBtn()
                ],
              ),
              Text("28,000,000 원", style: TextStyle(color: Colors.red))
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('- 키움증권'),
              Text("12,000,000 원")
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('- 미래에셋증권'),
              Text("16,000,000 원")
            ],
          ),
          widget
        ],
      ),
    );
  }

  Widget _body() {
    return Column(
      children: [
        _rowTile('현금', null),
        _rowTile('은행', null),
        _rowTile('투자', null),
        _rowTile('대출', null),
      ],
    );
  }

  Widget _addAssetBtn() {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return AssetDialog();
            }
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

import 'package:accountbook/src/component/datePicker.dart';
import 'package:accountbook/src/controller/asset_controller.dart';
import 'package:accountbook/src/controller/util_controller.dart';
import 'package:accountbook/src/page/chart.dart';
import 'package:accountbook/src/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CommonUtils _utils = CommonUtils();

  final AssetController _assetController = Get.put(AssetController());

  final UtilController _utilController = Get.put(UtilController());

  Widget _body() {
    return Container(
      child: Obx(
        () => Column(
          children: [
            myData(),
            datePicker(),
            for (var asset in _assetController.assetList)
              listRow(asset['title'], asset['money'], asset['id'])
          ],
        ),
      ),
    );
  }

  Widget myData() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      height: 100,
      color: Theme.of(context).primaryColor,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('이번 달 ${_utils.priceFormat(_assetController.total.value)}',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(
                  '${DateFormat('yy년 MM월 dd일 기준').format(DateTime.now())}',
                  style: TextStyle(color: Colors.black.withOpacity(0.5)),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                elevation: 5, primary: Colors.white, onPrimary: Colors.amber),
            onPressed: () => Get.to(() => ChartPage(),
                arguments: _utilController.date,
                transition: Transition.rightToLeft),
            icon: Image.asset(
              "assets/icons/pie-chart.png",
              width: 25,
              height: 25,
            ),
            label: Text(
              '차트보기',
              style: TextStyle(color: Colors.black),
            ),
          )
        ],
      ),
    );
  }

  Widget datePicker() {
    DateTime now = _utilController.date;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              icon: Icon(Icons.chevron_left, size: 30),
              onPressed: () => _utilController.changeDate(-1)),
          DatePickerComponent(
              now: DateTime.now(), fontColor: Colors.black, fontSize: 18),
          IconButton(
              icon: Icon(Icons.chevron_right, size: 30),
              onPressed: () => _utilController.changeDate(1)),
        ],
      ),
    );
  }

  Widget listRow(String title, int money, int assetId) {
    return Container(
      margin: EdgeInsets.only(bottom: 10, left: 16, right: 16),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 2.0,
            spreadRadius: 1.0,
            offset: Offset(2.0, 2.0), // shadow direction: bottom right
          )
        ],
      ),
      height: 90,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(title, style: TextStyle(fontSize: 16)),
                Text(_utils.priceFormat(money.abs()),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: money > 0 ? Colors.red : Colors.blue))
              ],
            ),
          ),
          Text('자세히', style: TextStyle(color: Colors.black.withOpacity(0.5)))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('홈', style: TextStyle(fontSize: 20)),
        actions: [
          Row(
            children: [
              Icon(Icons.import_export),
              SizedBox(width: 10),
              Icon(Icons.menu),
              SizedBox(width: 16),
            ],
          )
        ],
      ),
      body: _body(),
    );
  }
}

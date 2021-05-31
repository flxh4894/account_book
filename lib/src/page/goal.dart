import 'package:accountbook/src/controller/goal_controller.dart';
import 'package:accountbook/src/model/invest_info.dart';
import 'package:accountbook/src/utils/common_utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GoalPage extends StatefulWidget {

  @override
  _GoalPageState createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {
  final GoalController _goalController = Get.put(GoalController());
  final CommonUtils _utils = CommonUtils();


  @override
  void initState() {
    _goalController.init();
    super.initState();
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _header(),
          _barChart(),
          _needAssets(),
          _currentSaveAssets(),
          _myAssets()
        ],
      ),
    );
  }

  Widget _header(){
    return Container(
      color: Theme.of(context).primaryColor,
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('2021년 목표 금액', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold) ),
          SizedBox(height: 10),
          Text('21,000,000원', style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold) ),
        ],
      ),
    );
  }

  Widget _barChart() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        width: 500,
        height: 300,
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
        child: Obx(
          () => BarChart(
              BarChartData(
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: SideTitles(
                    showTitles: true,
                    getTextStyles: (value) =>
                    const TextStyle(color: Colors.black,fontSize: 14),
                    margin: 16,
                    getTitles: (double value) {
                      switch (value.toInt()) {
                        default:
                          return '${value.toInt()+1}월';
                      }
                    },
                  ),
                  leftTitles: SideTitles(
                    showTitles: false,
                  ),
                ),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                          '${groupIndex+1}월 \n ${_utils.priceFormat(rod.y.toInt())}',
                          TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold
                          )
                      );
                    }
                  )
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                barGroups: showingGroups(),
              )
          ),
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double y, bool isTouched) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 1 : y,
          colors: [isTouched ? Theme.of(context).primaryColor : Theme.of(context).primaryColor.withOpacity(0.5)],
          width: 22,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: 10000000,
            colors: [Colors.grey.withOpacity(0.2)]
          )
        ),
      ],
      showingTooltipIndicators: const [],
    );
  }

  List<BarChartGroupData> showingGroups() {

    List<BarChartGroupData> list = <BarChartGroupData>[];
    int month = 0;
    for(var data in _goalController.monthAssetList){
      list.add(makeGroupData(month, data.toDouble(),  false));
      month ++;
    }

    return list;
  }

  Widget _currentSaveAssets() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('총 저축 금액', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('${_utils.priceFormat(_goalController.yearTotalAsset.value)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),),
                SizedBox(height: 5),
                Text('${_utils.getDate(DateTime.now())} 기준', style: TextStyle(fontSize: 14, color: Colors.black.withOpacity(0.5))),
              ]
            ),
          ),
        ],
      ),
    );
  }

  Widget _needAssets() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('목표까지', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('12,900,000 원', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                SizedBox(height: 5),
                Text('한달에 2,500,000 원', style: TextStyle(fontSize: 14, color: Colors.black.withOpacity(0.5))),
              ]
          ),
        ],
      ),
    );
  }

  Widget _myAssets() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 16, top: 10, bottom: 10, right: 16),
      child: Obx(
        () => Column(
          children: [
            SizedBox(height: 20),
            for(InvestInfo invest in _goalController.yearInvestList)
              _assetTile(invest.title, '#${invest.tag}', invest.price),
            // _assetTile('마이여행파트너적금', '#우리은행 #여행자금', 2500000),
            // _assetTile('펀드', '#키움증권', 200000),
            // _assetTile('주식', '#키움증권', 2800000),
            // _assetTile('비트코인', '#업비트', 100000),
            // _assetTile('보유현금', '#신한은행', 2000000),
          ],
        ),
      ),
    );
  }

  Widget _assetTile(String title, String bank, int amount) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Text(bank, style: TextStyle(fontSize: 14, color: Colors.black.withOpacity(0.5))),
              ]
          ),
          Text(_utils.priceFormat(amount), style: TextStyle(fontSize: 14, color: Colors.black)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.1),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text('내 목표'),
      ),
      body: _body(),
    );
  }
}

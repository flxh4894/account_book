import 'package:accountbook/src/component/datePicker.dart';
import 'package:accountbook/src/component/list_row.dart';
import 'package:accountbook/src/controller/chart_controller.dart';
import 'package:accountbook/src/controller/util_controller.dart';
import 'package:accountbook/src/utils/common_utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import 'chart/indicator.dart';

class ChartPage extends StatefulWidget {
  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  final UtilController _utilController = Get.put(UtilController());
  final ChartController _chartController = Get.put(ChartController());
  final CommonUtils _utils = CommonUtils();
  int touchedIndex = -1;
  List<Color> colors;

  @override
  void initState() {
    colors = _chartController.colors;
    super.initState();
  }

  Widget _body() {
    return TabBarView(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                _pieChart(sections(CategoryType.Expense)),
                Divider(),
                _categoryList(CategoryType.Expense)
              ],
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                _pieChart(sections(CategoryType.Income)),
                Divider(),
                _categoryList(CategoryType.Income)
              ],
            ),
          ),
        ]
    );
  }

  Widget datePicker() {
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

  Widget _pieChart(List<PieChartSectionData> sections) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: AspectRatio(
        aspectRatio: 1,
        child: PieChart(
          PieChartData(
              borderData: FlBorderData(
                show: false,
              ),
              centerSpaceRadius: 70,
              sectionsSpace: 0,
              sections: sections),
        ),
      ),
    );
  }

  Widget _categoryList(CategoryType type) {
    var list;
    var total;
    int flag = 1;
    if(type == CategoryType.Income){
      total = _chartController.totalIncome.value;
      list = _chartController.incomeList;
    } else {
      total = _chartController.totalExpense.value;
      list = _chartController.expenseList;
      flag = -1;
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          ListRowComponent('5월 총액', total, 1),
          for(var category in list)
            ListRowComponent(category.text, category.price * flag, 1)
        ],
      ),
    );
  }



  List<PieChartSectionData> sections(CategoryType type) {
    var categories;
    if(type == CategoryType.Income) 
      categories = _chartController.incomeList;
    else
      categories = _chartController.expenseList;
    
    return List.generate(categories.length, (i) {
      final fontSize = 14.0;
      final radius = 80.0;

      return PieChartSectionData(
        color: colors[i],
        value: _chartController.getCategoryPercent(i, type),
        title: '${categories[i].text} \n ${_chartController.getCategoryPercent(i, type)}%',
        radius: radius,
        titleStyle: TextStyle(
            fontSize: fontSize,color: Colors.black),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text('소비 패턴', style: TextStyle(fontSize: 18)),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight + 50),
            child: Column(
              children: [
                datePicker(),
                TabBar(
                  indicatorColor: Theme.of(context).primaryColor,
                  labelStyle: TextStyle(fontSize: 16),
                  tabs: [
                    Tab(text: '지출'),
                    Tab(text: '수입' ),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: _body(),
      ),
    );
  }
}

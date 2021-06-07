import 'package:accountbook/src/component/list_row.dart';
import 'package:accountbook/src/controller/chart_controller.dart';
import 'package:accountbook/src/model/category_info.dart';
import 'package:accountbook/src/utils/common_utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChartPage extends StatelessWidget {
  // final UtilController _utilController = Get.find<UtilController>();
  final ChartController _chartController = Get.put(ChartController());
  final CommonUtils _utils = CommonUtils();

  Widget _body() {
    return TabBarView(
        children: [
          _chartController.expenseList.length == 0
          ? Center(
            child: Text('데이터가 없습니다.'),
          ) :
          SingleChildScrollView(
            child: Column(
              children: [
                _pieChart(sections(CategoryType.Expense)),
                Divider(),
                _categoryList(CategoryType.Expense)
              ],
            ),
          ),
          _chartController.incomeList.length == 0
              ? Center(
            child: Text('데이터가 없습니다.'),
          ) :
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
    return Obx(
      () => Container(
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                icon: Icon(Icons.chevron_left, size: 30),
                onPressed: () {
                  _chartController.changeDate(-1);
                  _chartController.getExpenseList(_chartController.date);
                  _chartController.getIncomeList(_chartController.date);
                }),
            Text(_utils.getYearMonth(_chartController.date),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold) ),
            IconButton(
                icon: Icon(Icons.chevron_right, size: 30),
                onPressed: () {
                  _chartController.changeDate(1);
                  _chartController.getExpenseList(_chartController.date);
                  _chartController.getIncomeList(_chartController.date);
                }),
          ],
        ),
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
          ListRowComponent('${_chartController.date.month}월 총액', total, 1),
          for(CategoryInfo category in list)
            ListRowComponent(category.name, category.price * flag, 1)
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
        color: _chartController.colors[i],
        value: _chartController.getCategoryPercent(i, type),
        title: '${categories[i].name} ${_chartController.getCategoryPercent(i, type)}%',
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
        body: Obx(() => _body()),
      ),
    );
  }
}

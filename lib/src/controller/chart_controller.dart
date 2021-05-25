import 'dart:ui';

import 'package:accountbook/src/helper/db_helper.dart';
import 'package:accountbook/src/model/category_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

enum CategoryType {Income, Expense}

class ChartController extends GetxController {
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await DatabaseHelper().database;
    return _database;
  }

  final List<Color> colors = [
    Color(0xffffafb0),
    Color(0xfffcffb0),
    Color(0xffcaa6fe),
    Color(0xffffafd8),
    Color(0xffaee4ff),
    Color(0xffffe4af),
    Color(0xffbee9b4),
  ];

  RxList<CategoryInfo> expenseList = <CategoryInfo>[].obs;
  RxInt totalExpense = 0.obs;

  RxList<CategoryInfo> incomeList = <CategoryInfo>[].obs;
  RxInt totalIncome = 0.obs;

  // 날짜 (현재일 기본값)
  Rx<DateTime> _date = DateTime.now().obs;
  DateTime get date => _date.value;

  // 월 변경
  void changeDate(int count) {
    int daysInMonth(DateTime date){
      var firstDayThisMonth = new DateTime(date.year, date.month, date.day);
      var firstDayNextMonth = new DateTime(firstDayThisMonth.year, firstDayThisMonth.month + count, firstDayThisMonth.day);
      return firstDayNextMonth.difference(firstDayThisMonth).inDays;
    }
    _date( _date.value.add(Duration(days: daysInMonth(_date.value))) );
  }

  @override
  void onInit() {
    getExpenseList(DateTime.now());
    getIncomeList(DateTime.now());
    super.onInit();
  }

  // 카테고리별 내역 가져오기
  void getExpenseList(DateTime date) async {
    final db = await database;
    final year = date.year;
    final month = date.month < 10 ? '0${date.month}' : date.month;
    final yearMonth = '$year$month';

    var list = await db.rawQuery("SELECT sum(A.price) AS price, A.category, B.name " +
        "FROM daily_cost A, category B " +
        "WHERE A.category = B.id AND B.type = 2 AND A.date BETWEEN '${yearMonth}01' AND '${yearMonth}31' " +
        "GROUP BY A.category " +
        "ORDER BY price DESC");

    expenseList(list.map((e) => CategoryInfo.fromJson(e)).toList() );
    setTotalExpense();
  }
  
  // 최종 소비 or 소득 금액 구하기
  void setTotalExpense() {
    int total = 0;
    for(var category in expenseList){
      total += category.price;
    }
    totalExpense(total);
  }

  void getIncomeList(DateTime date) async {
    final db = await database;
    final year = date.year;
    final month = date.month < 10 ? '0${date.month}' : date.month;
    final yearMonth = '$year$month';

    var list = await db.rawQuery("SELECT sum(A.price) AS price, A.category, B.name " +
        "FROM daily_cost A, category B " +
        "WHERE A.category = B.id AND B.type = 1 AND A.date BETWEEN '${yearMonth}01' AND '${yearMonth}31' " +
        "GROUP BY A.category " +
        "ORDER BY price DESC");

    incomeList( list.map((e) => CategoryInfo.fromJson(e)).toList() );
    setTotalIncome();
  }

  // 최종 소비 or 소득 금액 구하기
  void setTotalIncome() {
    int total = 0;
    for(var category in incomeList){
      total += category.price;
    }
    totalIncome(total);
  }

  double getCategoryPercent(int index, CategoryType type) {
    int result = 0;

    if(type == CategoryType.Income)
      result = (incomeList[index].price / totalIncome.value * 100).round();
    else
      result = (expenseList[index].price / totalExpense.value * 100).round();

    return result.toDouble();
  }
}

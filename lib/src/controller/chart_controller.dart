import 'dart:ui';

import 'package:accountbook/src/model/category_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum CategoryType {Income, Expense}

class ChartController extends GetxController {

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


  @override
  void onInit() {
    getExpenseList();
    getIncomeList();
    super.onInit();
  }

  // 카테고리별 내역 가져오기
  void getExpenseList() async {
    expenseList.addAll([
      CategoryInfo(type: 1, percent: 20, text: '식품', price: 250000),
      CategoryInfo(type: 2, percent: 10, text: '생활용품', price: 120000),
      CategoryInfo(type: 3, percent: 15, text: '취미생활', price: 170000),
      CategoryInfo(type: 4, percent: 15, text: '여가생활', price: 170000),
      CategoryInfo(type: 5, percent: 27, text: '전자제품', price: 320000),
      CategoryInfo(type: 6, percent: 13, text: '통신비', price: 43000),
    ]);
    
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

  void getIncomeList() async {
    incomeList.addAll([
      CategoryInfo(type: 99, percent: 20, text: '근로소득', price: 4500000),
      CategoryInfo(type: 99, percent: 20, text: '투자소득', price: 1250000),
    ]);
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

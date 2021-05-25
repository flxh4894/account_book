import 'package:accountbook/src/style/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GoalPage extends StatelessWidget {

  final MyStyle _myStyle = MyStyle();

  Widget _body() {
    return Column(
      children: [
        goalInfo(),
        TextButton(onPressed: () {
        }, child: Text('하나 더 찾아보자'))
      ],
    );
  }

  Widget goalInfo() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Text('2021년 목표 달성 금액 : 21,000,000원 ', style: TextStyle(fontSize: 16)),
          TextButton(onPressed: () {
          }, child: Text('??????????????'))
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text('내 목표', style: TextStyle(fontSize: 18)),
      ),
      body: _body(),
    );
  }
}

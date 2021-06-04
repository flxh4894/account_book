import 'package:accountbook/src/controller/sms_controller.dart';
import 'package:accountbook/src/page/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GuidePage04 extends StatefulWidget {
  @override
  _GuidePage04State createState() => _GuidePage04State();
}

class _GuidePage04State extends State<GuidePage04> {

  final SmsController _smsController = Get.find<SmsController>();
  bool flag = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Image.asset("assets/images/guide/page07_card_performance.png", width: size.width * 0.82),
              SizedBox(height: 20),
              Text("카드별 실적 현황을 통해\n혜택을 놓치지 마세요.", style: TextStyle(fontSize: 20), textAlign: TextAlign.center,),
              SizedBox(height: 20),
            ],
          ),
        )
    );
  }
}

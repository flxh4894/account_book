import 'package:accountbook/src/controller/sms_controller.dart';
import 'package:accountbook/src/page/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GuidePage06 extends StatefulWidget {
  @override
  _GuidePage06State createState() => _GuidePage06State();
}

class _GuidePage06State extends State<GuidePage06> {

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
              Text("마이페이지 > SMS 설정", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text("에서 설정 가능해요.", style: TextStyle(fontSize: 16)),
              SizedBox(height: 20),
              Image.asset("assets/images/guide/page06_sms.png", width: size.width * 0.75),
              SizedBox(height: 20),
              Text("SMS 자동 수신, 가져오기를 통해\n편하게 입력해 보세요.", style: TextStyle(fontSize: 20), textAlign: TextAlign.center,),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("※ SMS 자동 수신을 사용해 볼까요?", style: TextStyle()),
                  Switch(
                      value: flag,
                      activeTrackColor: Colors.white,
                      activeColor: Colors.pinkAccent,
                      onChanged: (value) {
                        _smsController.setReceiveFlag(value);
                        setState(() {
                          flag = value;
                        });
                      })
                ],
              )
            ],
          ),
        )
    );
  }
}

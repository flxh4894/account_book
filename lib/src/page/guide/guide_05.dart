import 'package:flutter/material.dart';

class GuidePage05 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("마이페이지 > SMS 설정 > 문구별 자산 연결", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text("에서 설정 가능해요.", style: TextStyle(fontSize: 16)),
              SizedBox(height: 20),
              Image.asset("assets/images/guide/page04_sms_asset.png", width: size.width * 0.6),
              SizedBox(height: 20),
              Text("SMS 문구별로\n은행 및 카드를 연동해 보세요.", style: TextStyle(fontSize: 20), textAlign: TextAlign.center,),
              SizedBox(height: 60),
            ],
          ),
        )
    );
  }
}

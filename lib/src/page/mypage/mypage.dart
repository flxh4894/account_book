import 'package:accountbook/src/page/mypage/my_assets.dart';
import 'package:accountbook/src/page/mypage/sms_settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyPage extends StatelessWidget {
  const MyPage({Key key}) : super(key: key);

  Widget _appBar() {
    return AppBar(
      title: Text('마이페이지'),
      elevation: 0,
      backgroundColor: Colors.white,
    );
  }

  Widget _body() {
    return Column(
      children: [
        _rowTile('나의 자산', Icons.assessment_outlined, MyAssetsPage()),
        _rowTile('SMS 설정', Icons.email_outlined, SmsSettingsPage()),
        _rowTile('설정', Icons.settings_outlined, null),
      ],
    );
  }

  Widget _rowTile(String title, IconData icon, Widget function) {
    return GestureDetector(
      onTap: () {
        Get.to(() => function);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
        margin: EdgeInsets.symmetric(horizontal: 16,vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 1.0,
              spreadRadius: 1.0,
              offset: Offset(2.0, 2.0), // shadow direction: bottom right
            )
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 25),
            SizedBox(width: 20),
            Text(title, style: TextStyle(fontSize: 16))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
    );
  }
}

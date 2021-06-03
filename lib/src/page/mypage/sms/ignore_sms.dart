import 'package:flutter/material.dart';

class IgnoreSmsListPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          Text("제외된 리스트")
        ],
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text('연동 제외 전화번호'),
      elevation: 0,
      backgroundColor: Colors.white,

    );
  }
}

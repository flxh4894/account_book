import 'package:accountbook/src/page/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GuidePage07 extends StatelessWidget {

  Future<bool> _changeFirstUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isFirst", false);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: GestureDetector(
      onTap: () {
        _changeFirstUser();
        Get.offAll(() => BottomNavigationPage());
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/guide/page05_icon.png",
            width: 150,
          ),
          SizedBox(height: 20),
          Text('시작하기',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)
          )
        ],
      ),
    ));
  }
}

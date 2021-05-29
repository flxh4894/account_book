import 'package:accountbook/src/page/calendar.dart';
import 'package:accountbook/src/page/goal.dart';
import 'package:accountbook/src/page/home.dart';
import 'package:accountbook/src/page/mypage.dart';
import 'package:flutter/material.dart';

import 'card_performance.dart';

class BottomNavigationPage extends StatefulWidget {
  @override
  _BottomNavigationPageState createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    HomePage(),
    CalendarPage(),
    GoalPage(),
    CardPerformancePage(),
    MyPage()
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: _children[_currentIndex],
          ),
          // AdTestPage(),
          SizedBox(height: 5)
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onTap,
        selectedItemColor: Colors.black,
        // selectedItemColor: Theme.of(context).primaryColor,
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '홈',
          ),
          new BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(Icons.calendar_today),
            label: '가계부',
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard_outlined),
            label: '내 목표',
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: '카드실적',
          ),
          new BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(Icons.account_circle_outlined),
            label: '마이페이지',
          )
        ],
      ),
    );
  }
}

import 'package:accountbook/src/component/datePicker.dart';
import 'package:accountbook/src/controller/util_controller.dart';
import 'package:accountbook/src/page/calendar/day_calendar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final UtilController _utilController = Get.find<UtilController>();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  Widget _appbar() {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.white,
      title: datePicker(),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: TabBar(
          indicatorColor: Theme.of(context).primaryColor,
          labelStyle: TextStyle(fontSize: 16),
          tabs: [
            Tab(text: '일별' ),
            Tab(text: '달력'),
          ],
        ),
      ),
    );
  }

  Widget datePicker() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              icon: Icon(Icons.chevron_left, size: 30),
              onPressed: () => _utilController.changeDate(-1)),
          DatePickerComponent(
              now: DateTime.now(), fontColor: Colors.black, fontSize: 18),
          IconButton(
              icon: Icon(Icons.chevron_right, size: 30),
              onPressed: () => _utilController.changeDate(1)),
        ],
      ),
    );
  }

  Widget _calendar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: TableCalendar(
        locale: 'ko-KR',
        daysOfWeekHeight: 30,
        firstDay: DateTime.utc(2010, 1, 1),
        lastDay: DateTime.utc(2099, 12, 31),
        headerVisible: false,
        shouldFillViewport: true,
        availableGestures: null,
        availableCalendarFormats: const {
          CalendarFormat.month: '주',
          CalendarFormat.twoWeeks: '월',
          CalendarFormat.week: '2주',
        },
        daysOfWeekStyle: DaysOfWeekStyle(weekendStyle: TextStyle(color: Colors.red)),
        weekendDays: [7],
        calendarStyle: CalendarStyle(
          weekendTextStyle: TextStyle(color: Colors.red),
          todayDecoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
        ),
        focusedDay: _focusedDay,
      )
    );
  }

  Widget _assetRow() {
    return Container(

    );
  }

  Widget _body() {
    return TabBarView(
        children: [
          DailyCalendarPage(),
          _calendar()
        ]
    );
    // return Column(
    //   children: [
    //     _calendar(),
    //   ],
    // );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: _appbar(),
        body: _body(),
      ),
    );
  }
}

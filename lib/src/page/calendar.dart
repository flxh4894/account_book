import 'package:accountbook/src/admob/ad_banner.dart';
import 'package:accountbook/src/component/datePicker.dart';
import 'package:accountbook/src/controller/cost_controller.dart';
import 'package:accountbook/src/controller/util_controller.dart';
import 'package:accountbook/src/page/calendar/calendar_edit.dart';
import 'package:accountbook/src/page/calendar/calendar_search.dart';
import 'package:accountbook/src/page/calendar/day_calendar.dart';
import 'package:accountbook/src/page/calendar/month_calendar.dart';
import 'package:accountbook/src/page/new_cost.dart';
import 'package:accountbook/src/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final UtilController _utilController = Get.find<UtilController>();
  final CostController _costController = Get.put(CostController());
  final CommonUtils _utils = CommonUtils();

  Widget _appbar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: datePicker(),
      actions: [
        IconButton(
          onPressed: ()=>Get.to(() => CalendarSearchPage()),
          icon: Icon(Icons.search)
        ),
        PopupMenuButton(
          icon: Icon(Icons.more_horiz),
          itemBuilder: (context) => [
            PopupMenuItem(
                value: 1,
                child: Text('삭제하기')
            ),
          ],
          onSelected: (item) {
            _menuActions(item);
          },
        )
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight+50),
        child: Column(
          children: [
            TabBar(
              indicatorColor: Theme.of(context).primaryColor,
              labelStyle: TextStyle(fontSize: 16),
              tabs: [
                Tab(text: '일별' ),
                Tab(text: '달력'),
              ],
            ),
            Obx(
              () => Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text('수입'),
                        Text('${_utils.priceFormat(_costController.monthTotalPlus.value)}', style: TextStyle(color: Colors.red),),
                      ],
                    ),
                    Column(
                      children: [
                        Text('지출'),
                        Text('${_utils.priceFormat(_costController.monthTotalMinus.value)}', style: TextStyle(color: Colors.blue)),
                      ],
                    ),
                    Column(
                      children: [
                        Text('합계'),
                        Text('${_utils.priceFormat(_costController.monthTotalPlus.value - _costController.monthTotalMinus.value)}'),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ]
        ),
      ),
    );
  }

  void _menuActions(int item) {
    switch(item){
      case 1:
        Get.to(() => CalendarEditPage(), transition: Transition.noTransition);
        break;
    }
  }

  Widget datePicker() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              icon: Icon(Icons.chevron_left, size: 30),
              onPressed: () {
                _utilController.changeDate(-1);
                _costController.getMonthCostContent(_utilController.date);
              },
          ),
          DatePickerComponent(
              now: DateTime.now(), fontColor: Colors.black, fontSize: 18),
          IconButton(
              icon: Icon(Icons.chevron_right, size: 30),
              onPressed: () {
                _utilController.changeDate(1);
                _costController.getMonthCostContent(_utilController.date);
              },
          )
        ],
      ),
    );
  }

  Widget _body() {
    return Column(
      children: [
        Expanded(
          child: TabBarView(
            children: [
              DailyCalendarPage(),
              MonthCalendarPage()
            ]
          ),
        ),
        AdMobBannerAd()
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: _appbar(),
        body: _body(),
        floatingActionButton: Padding(
          padding: EdgeInsets.symmetric(vertical: 50),
          child: FloatingActionButton(
            onPressed: () => Get.to(() => NewCostPage()),
            child: Icon(Icons.add, color: Colors.white),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat
      ),
    );
  }
}

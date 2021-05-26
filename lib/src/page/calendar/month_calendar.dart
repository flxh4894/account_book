import 'package:accountbook/src/controller/cost_controller.dart';
import 'package:accountbook/src/controller/util_controller.dart';
import 'package:accountbook/src/model/daily_cost.dart';
import 'package:accountbook/src/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class MonthCalendarPage extends StatefulWidget {
  const MonthCalendarPage({Key key}) : super(key: key);

  @override
  _MonthCalendarPageState createState() => _MonthCalendarPageState();
}

class _MonthCalendarPageState extends State<MonthCalendarPage> {
  final CostController _costController = Get.find<CostController>();
  final UtilController _utilController = Get.find<UtilController>();
  final CommonUtils _utils = CommonUtils();
  // DateTime _focusedDay = DateTime.now();
  // DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        color: Colors.white,
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
          eventLoader: _costController.getEventsForDay,
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, day, focusedDay) {
              String _day = DateFormat('dd').format(day).toString();
              var color = Colors.black;
              if (day.weekday == 7)
                color = Colors.red;
              else if (day.weekday == 6) color = Colors.blue;
              return Container(
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 0.1, color: Colors.black.withOpacity(0.2))),
                child: Text(
                  _day,
                  style: TextStyle(color: color),
                ),
              );
            },
            todayBuilder: (context, day, focusedDay) {
              String _day = DateFormat('dd').format(day).toString();
              return Container(
                color: Theme.of(context).primaryColor,
                alignment: Alignment.topLeft,
                child: Text(
                  _day,
                  style: TextStyle(color: Colors.white),
                ),
              );
            },
            outsideBuilder: (context, day, focusedDay) {
              String _day = DateFormat('dd').format(day).toString();
              return Container(
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 0.1, color: Colors.black.withOpacity(0.2))),
                child: Text(
                  _day,
                  style: TextStyle(color: Colors.black.withOpacity(0.3)),
                ),
              );
            },
            markerBuilder: (context, day, List<DailyCost> events) {
              int plus = 0;
              int minus = 0;
              for (DailyCost event in events) {
                if (event.type == 1)
                  plus += event.price;
                else
                  minus += event.price;
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  minus == 0
                      ? Container()
                      : Text(
                          '${_utils.priceFormatOnlyNum(minus)}',
                          style: TextStyle(color: Colors.blue, fontSize: 10),
                        ),
                  plus == 0
                      ? Container()
                      : Text(
                          '${_utils.priceFormatOnlyNum(plus)}',
                          style: TextStyle(color: Colors.red, fontSize: 10),
                        ),
                ],
              );
            },
          ),
          focusedDay: _utilController.date,
          onDaySelected: (selectedDay, _){
            print('${selectedDay.toString()} 팝업 띄워주기');
          },
          // daysOfWeekStyle: DaysOfWeekStyle(weekendStyle: TextStyle(color: Colors.red)),
          // weekendDays: [7],
          // calendarStyle: CalendarStyle(
          //   weekendTextStyle: TextStyle(color: Colors.red),
          //   todayDecoration: BoxDecoration(
          //     color: Theme.of(context).primaryColor,
          //     shape: BoxShape.circle,
          //   ),
          //   selectedDecoration: BoxDecoration(
          //     color: Colors.grey.withOpacity(0.5),
          //     shape: BoxShape.circle,
          //   ),
          // ),
        ),
      ),
    );
  }
}

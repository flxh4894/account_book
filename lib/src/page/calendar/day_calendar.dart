import 'package:accountbook/src/controller/cost_controller.dart';
import 'package:accountbook/src/controller/util_controller.dart';
import 'package:accountbook/src/model/daily_cost.dart';
import 'package:accountbook/src/page/calendar/calendar_edit.dart';
import 'package:accountbook/src/page/edit_cost.dart';
import 'package:accountbook/src/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DailyCalendarPage extends StatefulWidget {
  @override
  _DailyCalendarPageState createState() => _DailyCalendarPageState();
}

class _DailyCalendarPageState extends State<DailyCalendarPage> {
  final CostController _costController = Get.find<CostController>();
  final CommonUtils _utils = CommonUtils();

  // 삭제 후 콜백 처리
  void deleteCallback(DailyCost dailyCost) {
    var day = dailyCost.date.substring(6,8);

    _costController.dailyCostList[day].remove(dailyCost);
    _costController.dailyCostList.refresh();

    if (dailyCost.type == 1)
      _costController.monthTotalPlus(_costController.monthTotalPlus.value - dailyCost.price);
    else if (dailyCost.type == 2)
      _costController.monthTotalMinus(_costController.monthTotalMinus.value - dailyCost.price);
    else
      _costController.monthTotalInvest(_costController.monthTotalInvest.value - dailyCost.price);

    _costController.setAssetList();
  }

  Widget _dayListTile(String day, List<DailyCost> list) {
    var totalMinus = 0;
    var totalPlus = 0;

    for(var content in list){
      if(content.type == 1) {
        totalPlus += content.price;
      } else if(content.type == 2) {
        totalMinus += content.price;
      }
    }

    var now = _utils.convertDateTime(list[0].date);
    var color = Colors.black.withOpacity(0.5);
    if(now.weekday == 6){
      color = Colors.blue;
    } else if(now.weekday == 7){
      color = Colors.red;
    }

    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      margin: EdgeInsets.only(bottom: 10),
      child: Column(children: [
        Row(
          children: [
            Text(day,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(width: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text('${_utils.getYearMonth(now)}',
                //     style: TextStyle(
                //         fontSize: 14, color: Colors.black.withOpacity(0.5))
                // ),
                Container(
                  decoration: BoxDecoration(
                      color: color ,
                      borderRadius: BorderRadius.circular(5)),
                  padding: EdgeInsets.all(2),
                  child: Text('${_utils.getDay(now)}',
                      style: TextStyle(color: Colors.white, fontSize: 12)),
                )
              ],
            ),
            Spacer(),
            Text('${_utils.priceFormat(totalPlus)}', style: TextStyle(color: Colors.red, fontSize: 14)),
            SizedBox(width: 30),
            Text('${_utils.priceFormat(totalMinus)}',
                style: TextStyle(color: Colors.blue, fontSize: 14)),
          ],
        ),
        Divider(),
        for(var content in list)
          contentDetail(content)
      ]),
    );
  }

  Widget contentDetail(DailyCost content) {
    var color = Colors.red;
    if(content.type == 2)
      color = Colors.blue;
    else if(content.type == 3)
      color = Colors.green;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Theme.of(context).primaryColor.withOpacity(0.2),
        onTap: () {
          Get.to(() => EditCostPage(), arguments: {'content': content, 'callBack': deleteCallback});
        },
        onLongPress: () {
          Get.to(() => CalendarEditPage(),
            duration: Duration(seconds: 0),
            arguments: {
              'id': content.id,
              'price': content.price,
              'type': content.type
            },
            transition: Transition.noTransition);
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  width: 80,
                  child: Text(content.category,
                      style: TextStyle(color: Colors.black.withOpacity(0.5))
                  )
              ),
              SizedBox(width: 30),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(content.title, overflow: TextOverflow.ellipsis),
                    Text('${content.date.substring(8,10)}:${content.date.substring(10,12)} ${content.assetNm}',
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.5), fontSize: 12)
                    ),
                  ],
                ),
              ),
              Text('${_utils.priceFormat(content.price)}',
                  style: TextStyle(
                    color: color
                  )
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        child: _costController.dailyCostList.length == 0 ?
        Center(child: Text('데이터가 없습니다.'),) :
        ListView.builder(
          itemCount: _costController.dailyCostList.length,
          itemBuilder: (context, index) {
            List<String> keys = _costController.dailyCostList.keys.toList();

            // Last 일 때 Bottom 에 Padding 을 주기 위함
            if(index != _costController.dailyCostList.length - 1)
              return _dayListTile(keys[index], _costController.dailyCostList[keys[index]]);
            else
              return Container(
                margin: EdgeInsets.only(bottom: 50),
                child: _dayListTile(keys[index], _costController.dailyCostList[keys[index]])
              );
          }
        ),
      ),
    );
  }
}

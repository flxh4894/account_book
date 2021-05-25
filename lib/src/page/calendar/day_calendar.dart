import 'package:accountbook/src/controller/cost_controller.dart';
import 'package:accountbook/src/model/daily_cost.dart';
import 'package:accountbook/src/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DailyCalendarPage extends StatelessWidget {

  final CostController _costController = Get.find<CostController>();
  final CommonUtils _utils = CommonUtils();

  Widget _dayListTile(String day, List<DailyCost> list) {
    var totalMinus = 0;
    var totalPlus = 0;

    for(var content in list){
      if(content.type == 1) {
        totalPlus += content.price;
      } else {
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
                Text('${_utils.getYearMonth(now)}',
                    style: TextStyle(
                        fontSize: 14, color: Colors.black.withOpacity(0.5))
                ),
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
    return Container(
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
                Text('${content.date.substring(8,10)}:${content.date.substring(10,12)} 삼성카드',
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.5), fontSize: 12)
                ),
              ],
            ),
          ),
          Text('${_utils.priceFormat(content.price)}', style: TextStyle(color: content.type == 1 ? Colors.red : Colors.blue))
        ],
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

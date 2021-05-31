import 'package:accountbook/src/controller/cost_controller.dart';
import 'package:accountbook/src/model/daily_cost.dart';
import 'package:accountbook/src/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CalendarEditPage extends StatefulWidget {
  @override
  _CalendarEditPageState createState() => _CalendarEditPageState();
}

class _CalendarEditPageState extends State<CalendarEditPage> {
  final CostController _costController = Get.find<CostController>();
  final CommonUtils _utils = CommonUtils();
  bool selectMode = true;
  List<int> selectedList = <int>[];
  int total = 0;


  @override
  void initState() {
    selectedList.add(Get.arguments['id']);
    var type = 1;
    if(Get.arguments['type'] == 2){
      type = -1;
    }
    total += Get.arguments['price'] * type;
    super.initState();
  }

  Widget _appbar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: Text('수정'),
      actions: [
        IconButton(
            icon: Icon(Icons.delete_outlined),
            onPressed: () {
              _costController.removeCostContent(selectedList);
            }
        ),
        IconButton(
            icon: Icon(Icons.more_horiz),
            onPressed: () {}
        )
      ],
    );
  }
  
  Widget _body() {
    return Obx(
          () => Container(
        child: Column(
          children: [
            _selectedInfo(),
            Expanded(
              child: ListView.builder(
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
          ]
        ),
      ),
    );
  }

  Widget _selectedInfo() {
    return Container(
      color: Theme.of(context).primaryColor,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${selectedList.length}건이 선택되었습니다.', style: TextStyle(color: Colors.white)),
          Text('${_utils.priceFormat(total)}',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold
              )
          )
        ],
      ),
    );
  }

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
    return Material(
      color: selectedList.contains(content.id) ?
      Theme.of(context).primaryColor.withOpacity(0.5) : Colors.transparent,
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Theme.of(context).primaryColor.withOpacity(0.2),
        onTap: () {
          setState(() {
            var type = 1;
            if(content.type == 2)
              type = -1;

            if(selectedList.contains(content.id)){
              selectedList.remove(content.id);
              total -= content.price * type;
            }
            else {
              selectedList.add(content.id);
              total += content.price * type;
            }

            if(selectedList.length == 0)
              Get.back();
          });
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
              Text('${_utils.priceFormat(content.price)}', style: TextStyle(color: content.type == 1 ? Colors.red : Colors.blue))
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(),
      body: _body(),
    );
  }
}

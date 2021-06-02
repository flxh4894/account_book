import 'package:accountbook/src/controller/goal_controller.dart';
import 'package:accountbook/src/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class YearGoalDialog extends StatefulWidget {
  @override
  _YearGoalDialogState createState() => _YearGoalDialogState();
}

class _YearGoalDialogState extends State<YearGoalDialog> {
  final TextEditingController _textGoal = TextEditingController();
  final GoalController _goalController = Get.find<GoalController>();
  final CommonUtils _utils = CommonUtils();
  String priceFormat = "0 원";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 1,
        backgroundColor: Colors.white,
        child: Container(
          height: MediaQuery
              .of(context)
              .size
              .height * 0.3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: Theme
                      .of(context)
                      .primaryColor,
                ),
                child: Center(
                    child: Text('목표금액 설정하기',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)
                    )
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${DateTime.now().year}년 목표금액'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 150,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: _textGoal,
                            onChanged: (text){
                              setState(() {
                                if(text == "")
                                  priceFormat = _utils.priceFormat(0);
                                else
                                  priceFormat = _utils.priceFormat(int.parse(text));
                              });
                            },
                          ),
                        ),
                        Text('원'),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text('( $priceFormat )')
                  ],
                )
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(onPressed: () {
                    Get.back();
                  }, child: Text('취소', style: TextStyle(color: Colors.black))),
                  GestureDetector(
                    onTap: () {
                      _goalController.insertYearGoal(int.parse(_textGoal.text));
                      Get.back();
                    },
                    child: Row(
                      children: [
                        Text('설정', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        )
    );
  }
}

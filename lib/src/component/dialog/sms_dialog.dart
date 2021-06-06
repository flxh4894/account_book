import 'package:accountbook/src/controller/asset_controller.dart';
import 'package:accountbook/src/page/mypage/sms/sms_asset_match.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'add_asset_dialog.dart';

class SmsDialog extends StatefulWidget {
  final Function callback;
  SmsDialog({this.callback});

  @override
  _SmsDialogState createState() => _SmsDialogState();
}

class _SmsDialogState extends State<SmsDialog> {
  final TextEditingController _textDay = TextEditingController()..text = "60";
  bool smsFlag = false;

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
              .height * 0.35,
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
                    child: Text('SMS 가져오기',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)
                    )
                ),
              ),
              Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('최근'),
                      Container(
                        width: 50,
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          controller: _textDay,
                          keyboardType: TextInputType.number,
                        )
                      ),
                      Text("일 이내의 문자 가져오기")
                    ],
                  )
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('잠깐!'),
                    GestureDetector(
                        child: Text('문구별 자산 연동', style: TextStyle(color: Colors.blue, fontSize: 18)),
                        onTap: () {
                          print('click');
                          Get.back();
                          Get.to(() => SmsAssetMatchPage());
                        }
                    ),
                    Text(' 설정 하셨나요?'),
                  ],
                )
              ),
              Container(
                child: Center(
                  child: smsFlag ? CircularProgressIndicator() : Text(""),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(onPressed: () {
                    Get.back();
                  }, child: Text('취소', style: TextStyle(color: Colors.black))),
                  GestureDetector(
                    onTap: () {
                      if(!smsFlag) {
                        setState(() {
                          smsFlag = true;
                        });
                        widget.callback(int.parse(_textDay.text));
                      }
                    },
                    child: Row(
                      children: [
                        Text('가져오기', style: TextStyle(color: Colors.red)),
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

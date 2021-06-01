import 'package:accountbook/src/component/dialog/sms_dialog.dart';
import 'package:accountbook/src/controller/sms_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class SmsSettingsPage extends StatefulWidget {
  @override
  _SmsSettingsPageState createState() => _SmsSettingsPageState();
}

class _SmsSettingsPageState extends State<SmsSettingsPage> {
  final SmsController _smsController = Get.find<SmsController>();
  Future<bool> _permissionCheck() async {
    bool per = true;
    Map<Permission, PermissionStatus> list = await [Permission.sms].request();

    list.forEach((key, value) {
      if(!value.isGranted){
        per = false;
      }
    });

    return per;
  }

  @override
  void initState() {
    _permissionCheck().then((value) => print(value));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SMS 설정'),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Text('SMS 가져오기'),
                TextButton(onPressed: (){
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return SmsDialog(callback: _smsController.getNativeValue);
                    }
                  );
                },
                    child: Text('가져오기'))
              ],
            ),
            Row(
              children: [
                Text('SMS 자동 수신'),
                Obx(
                  () => Switch(
                      activeTrackColor: Colors.yellow,
                      activeColor: Colors.orangeAccent,
                      value: _smsController.receiveFlag.value,
                      onChanged: (value) {
                        print(value);
                        _smsController.setReceiveFlag(value);
                      }
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

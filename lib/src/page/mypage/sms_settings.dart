import 'package:accountbook/src/component/dialog/sms_dialog.dart';
import 'package:accountbook/src/controller/sms_controller.dart';
import 'package:accountbook/src/page/mypage/sms/ignore_sms.dart';
import 'package:accountbook/src/page/mypage/sms/sms_asset_match.dart';
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

  Widget _rowTile(String title, Widget widget) {
    widget = widget == null ? Container() : widget;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
      margin: EdgeInsets.symmetric(horizontal: 16,vertical: 5),
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 1.0,
            spreadRadius: 1.0,
            offset: Offset(2.0, 2.0), // shadow direction: bottom right
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 16)),
          widget
        ],
      ),
    );
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _rowTile('SMS 가져오기',
                GestureDetector(
                    onTap: (){
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return SmsDialog(callback: _smsController.getNativeValue);
                          }
                      );
                    },
                    child: Text('가져오기', style: TextStyle(color: Theme.of(context).primaryColor))
                )
            ),
            _rowTile('SMS 자동 수신',
                Obx(
                      () => Switch(
                      activeTrackColor: Colors.yellow,
                      activeColor: Colors.orangeAccent,
                      value: _smsController.receiveFlag.value,
                      onChanged: (value) {
                        _smsController.setReceiveFlag(value);
                      }
                  ),
                )
            ),
            GestureDetector(
              onTap: () => Get.to(() => IgnoreSmsListPage()),
              child: _rowTile('연동 제외 번호 설정', null)
            ),
            GestureDetector(
              onTap: () => Get.to(() => SmsAssetMatchPage()),
              child: _rowTile('문구별 자산 연결', null)),
          ],
        ),
      ),
    );
  }
}

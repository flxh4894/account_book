import 'package:accountbook/src/component/dialog/sms_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class SmsSettingsPage extends StatefulWidget {
  @override
  _SmsSettingsPageState createState() => _SmsSettingsPageState();
}

class _SmsSettingsPageState extends State<SmsSettingsPage> {
  static const platform = const MethodChannel('com.polymorph.account_book/read_sms');
  String _value = 'null';

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

  Future<void> _getNativeValue() async {
    String value;
    try {
      List a = await platform.invokeMethod('getValue');
      Get.back();
      print( DateTime.now().subtract(Duration(days: 365)) );
      Get.snackbar("SMS 가져오기", "${a.length}건 가져오기 성공",
          snackPosition: SnackPosition.BOTTOM);
      // a.forEach((element) {
      //   print(element);
      // });
      value = a[0]['text'];
    } on PlatformException catch (e) {
      value = '네이티브 에러 : ${e.message}';
    }

    setState(() {
      _value = value;
    });
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
                Text('SMS가져오기'),
                TextButton(onPressed: (){
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return SmsDialog(callback: _getNativeValue,);
                    }
                  );

                  // _getNativeValue();
                },
                    child: Text('가져오기'))
              ],
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      var a = await platform.invokeMethod('getValue');
      value = a.toString();
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('네이티브 값'),
            TextButton(onPressed: (){
              _getNativeValue();
            },
            child: Text('$_value'))
          ],
        ),
      ),
    );
  }
}

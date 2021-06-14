import 'package:accountbook/src/admob/ad_banner.dart';
import 'package:accountbook/src/controller/sms_controller.dart';
import 'package:accountbook/src/controller/util_controller.dart';
import 'package:accountbook/src/page/mypage/asset_management.dart';
import 'package:accountbook/src/page/mypage/my_assets.dart';
import 'package:accountbook/src/page/mypage/sms_settings.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final BannerAd myBanner = BannerAd(
    adUnitId: 'ca-app-pub-3940256099942544/6300978111',
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(),
  );

  final BannerAdListener listener = BannerAdListener(
    // Called when an ad is successfully received.
    onAdLoaded: (Ad ad) => print('Ad loaded.'),
    // Called when an ad request failed.
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      // Dispose the ad here to free resources.
      ad.dispose();
      print('Ad failed to load: $error');
    },
    // Called when an ad opens an overlay that covers the screen.
    onAdOpened: (Ad ad) => print('Ad opened.'),
    // Called when an ad removes an overlay that covers the screen.
    onAdClosed: (Ad ad) => print('Ad closed.'),
    // Called when an impression occurs on the ad.
    onAdImpression: (Ad ad) => print('Ad impression.'),
  );


  @override
  void initState() {
    myBanner.load();
    super.initState();
  }

  Widget _appBar() {
    return AppBar(
      title: Text('마이페이지'),
      elevation: 0,
      backgroundColor: Colors.white,
    );
  }

  Widget _adWidget() {
    final AdWidget adWidget = AdWidget(ad: myBanner);
    final Container adContainer = Container(
      alignment: Alignment.center,
      child: adWidget,
      width: myBanner.size.width.toDouble(),
      height: myBanner.size.height.toDouble(),
    );
    return adContainer;
  }

  Widget _body() {
    return Column(
      children: [
        AdMobBannerAd(adSize: AdSize.largeBanner),
        _rowTile('나의 자산', Icons.assessment_outlined, MyAssetsPage(), 0),
        _rowTile('SMS 설정', Icons.email_outlined, SmsSettingsPage(), 1),
        _rowTile('은행 및 카드관리', Icons.paid_outlined, AssetManagementPage(), 0),
        // _rowTile('설정(미구현)', Icons.settings_outlined, null),
      ],
    );
  }

  Widget _rowTile(String title, IconData icon, Widget function, int type) {
    return GestureDetector(
      onTap: () {
          if(type == 1) {
            Get.find<UtilController>().permissionCheck()
                .then((value) {
              if(value == false){
                Get.find<SmsController>().setReceiveFlag(false);
                Get.defaultDialog(
                    barrierDismissible: true,
                    title: '',
                    textConfirm: '확인',
                    confirmTextColor: Colors.white,
                    textCancel: '설정으로 가기',
                    onCancel: AppSettings.openAppSettings,
                    onConfirm: () => Get.back(),
                    content: Center(
                      child: Text('SMS 권한을 허용해 주세요.'),
                    )
                );
              } else {
                Get.to(() => function);
              }
            });
          } else {
            Get.to(() => function);
          }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
        margin: EdgeInsets.symmetric(horizontal: 16,vertical: 5),
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
          children: [
            Icon(icon, size: 25),
            SizedBox(width: 20),
            Text(title, style: TextStyle(fontSize: 16))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
    );
  }
}

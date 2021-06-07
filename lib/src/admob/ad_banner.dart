import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobBannerAd extends StatefulWidget {
  final AdSize adSize;
  AdMobBannerAd({this.adSize});

  @override
  _AdMobBannerAdState createState() => _AdMobBannerAdState();
}

class _AdMobBannerAdState extends State<AdMobBannerAd> {
  BannerAd myBanner;

  final BannerAdListener listener = BannerAdListener(
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
    print(widget.adSize);
    myBanner = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111', // 광고 아이디 설정
      size: widget.adSize == null ? AdSize.banner : widget.adSize,
      request: AdRequest(),
      listener: BannerAdListener(),
    );
    
    myBanner.load();
    super.initState();
  }

  @override
  void dispose() {
    myBanner.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return _adWidget();
  }
}

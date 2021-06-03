import 'package:accountbook/src/controller/card_controller.dart';
import 'package:accountbook/src/controller/cost_controller.dart';
import 'package:accountbook/src/controller/util_controller.dart';
import 'package:accountbook/src/page/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    const MaterialColor kPrimaryColor = const MaterialColor(
      0xffcaa6fe,
      const <int, Color>{
        50: const Color(0xffcaa6fe),
        100: const Color(0xffcaa6fe),
        200: const Color(0xffcaa6fe),
        300: const Color(0xffcaa6fe),
        400: const Color(0xffcaa6fe),
        500: const Color(0xffcaa6fe),
        600: const Color(0xffcaa6fe),
        700: const Color(0xffcaa6fe),
        800: const Color(0xffcaa6fe),
        900: const Color(0xffcaa6fe),
      },
    );

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: '자산을 늘려라',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('ko', ''),
      ],
      theme: ThemeData(
        // scaffoldBackgroundColor: Colors.white,
        primarySwatch: kPrimaryColor,
        primaryColor: Color(0xffcaa6fe),
        primaryTextTheme: TextTheme(
          headline6: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold
          )
        ),
      ),
      initialBinding: BindingsBuilder(() {
        Get.put(UtilController());
        Get.put(CostController());
        Get.put(CardController());
      }),
      home: BottomNavigationPage()
    );
  }
}
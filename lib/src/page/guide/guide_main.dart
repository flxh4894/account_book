import 'package:accountbook/src/page/guide/guide_01.dart';
import 'package:accountbook/src/page/guide/guide_02.dart';
import 'package:accountbook/src/page/guide/guide_03.dart';
import 'package:accountbook/src/page/guide/guide_07.dart';
import 'package:accountbook/src/page/guide/guide_06.dart';
import 'package:accountbook/src/page/guide/guide_04.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'guide_05.dart';
import 'guide_07.dart';
import 'guide_06.dart';
import 'guide_04.dart';

class GuideMain extends StatefulWidget {
  @override
  _GuideMainState createState() => _GuideMainState();
}

class _GuideMainState extends State<GuideMain> {
  int _current = 0;
  List<Widget> pageList = [
    GuidePage01(),
    GuidePage02(),
    GuidePage03(),
    GuidePage04(),
    GuidePage05(),
    GuidePage06(),
    GuidePage07(),
  ];
  var list = [1,2,3,4,5,6,7];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }

  Widget _body() {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Stack(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: size.height,
              viewportFraction: 1,
              enableInfiniteScroll: false,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }
            ),
            items: list.map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.5)
                      ),
                      child: pageList[i-1]
                  );
                },
              );
            }).toList(),
          ),
          Positioned(
            bottom: 0,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: list.map((value) {
                int index = list.indexOf(value);
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == index
                        ? Colors.white
                        : Color.fromRGBO(0, 0, 0, 0.4),
                  ),
                );
              }).toList(),
            ),
          ),
        ]
      ),
    );
  }
}

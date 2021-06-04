import 'package:flutter/material.dart';

class GuidePage03 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/guide/page03_card.png", width: size.width * 0.5),
            SizedBox(height: 20),
            Text("사용하는 은행과 카드를\n추가해 보세요!", style: TextStyle(fontSize: 20), textAlign: TextAlign.center,),
          ],
        ),
      )
    );
  }
}

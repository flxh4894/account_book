import 'package:flutter/material.dart';

class GuidePage02 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/guide/page02_list.png", width: size.width * 0.6),
              SizedBox(height: 20),
              Text("가계부를 작성해\n자산을 관리해 보세요!", style: TextStyle(fontSize: 20), textAlign: TextAlign.center,),
            ],
          ),
        )
    );
  }
}

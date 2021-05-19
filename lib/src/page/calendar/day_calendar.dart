import 'package:flutter/material.dart';

class DailyCalendarPage extends StatelessWidget {
  Widget _dayListTile() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      margin: EdgeInsets.only(bottom: 10),
      child: Column(children: [
        Row(
          children: [
            Text('19',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(width: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('2021.05',
                    style: TextStyle(
                        fontSize: 14, color: Colors.black.withOpacity(0.5))),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(5)),
                  padding: EdgeInsets.all(2),
                  child: Text('월요일',
                      style: TextStyle(color: Colors.white, fontSize: 12)),
                )
              ],
            ),
            Spacer(),
            Text('0원', style: TextStyle(color: Colors.red, fontSize: 14)),
            SizedBox(width: 30),
            Text('21,100,000원',
                style: TextStyle(color: Colors.blue, fontSize: 14)),
          ],
        ),
        Divider(),
        Container(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  width: 70,
                  child: Text('전자제품',
                      style: TextStyle(color: Colors.black.withOpacity(0.5))
                  )
              ),
              Container(
                width: 150,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('플레이스테이션5 SSG.com', overflow: TextOverflow.ellipsis),
                    Text('오후 13:30 삼성카드',
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.5), fontSize: 12)
                    ),
                  ],
                ),
              ),
              Text('650,000원', style: TextStyle(color: Colors.blue))
            ],
          ),
        )
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          itemCount: 30,
          itemBuilder: (context, index) {
            return _dayListTile();
          }),
    );
  }
}

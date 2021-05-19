import 'package:accountbook/src/utils/common_utils.dart';
import 'package:flutter/material.dart';

class ListRowComponent extends StatelessWidget {
  final CommonUtils _utils = CommonUtils();

  final String title;
  final int money;
  final int assetId;

  ListRowComponent(this.title, this.money, this.assetId);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10, left: 16, right: 16),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 2.0,
            spreadRadius: 1.0,
            offset: Offset(2.0, 2.0), // shadow direction: bottom right
          )
        ],
      ),
      height: 90,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(title, style: TextStyle(fontSize: 16)),
                Text(_utils.priceFormat(money.abs()),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: money > 0 ? Colors.red : Colors.blue))
              ],
            ),
          ),
          Text('자세히', style: TextStyle(color: Colors.black.withOpacity(0.5)))
        ],
      ),
    );
  }
}

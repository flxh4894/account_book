import 'package:accountbook/src/component/dialog/asset_dialog.dart';
import 'package:flutter/material.dart';

class MyAssetsPage extends StatelessWidget {

  Widget _body() {
    return Column(
      children: [

      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('나의 자산'),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AssetDialog();
                  }
              );
            },
            child: Row(
              children: [
                Image.asset(
                  "assets/icons/credit_card.png",
                  width: 40,
                  height: 40,
                ),
                Text('자산추가'),
                SizedBox(width: 20)
              ],
            ),
          )
        ],
      ),
    );
  }
}

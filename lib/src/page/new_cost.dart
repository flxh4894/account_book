
import 'package:accountbook/src/component/calculator.dart';
import 'package:accountbook/src/component/dialog/asset_dialog.dart';
import 'package:accountbook/src/controller/cost_controller.dart';
import 'package:accountbook/src/model/asset_content.dart';
import 'package:accountbook/src/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NewCostPage extends StatefulWidget {
  @override
  _NewCostPageState createState() => _NewCostPageState();
}

class _NewCostPageState extends State<NewCostPage> {
  final textDate = TextEditingController();
  final textTitle = TextEditingController();
  final CommonUtils _utils = CommonUtils();
  final CostController _costController = Get.find<CostController>();

  DateTime now = DateTime.now();
  TimeOfDay picked = TimeOfDay.now();
  String hour = '';
  String min = '';
  String title = '지출';
  
  int categoryId = -1;
  String category = '카테고리 선택';

  int assetId = -1; // 기본 현금
  String asset = '자산 선택';
  
  String price = '0';
  int assetType = 2; // 자산 형태 선택 ( 소비 or 지출 )

  @override
  void initState() {
    hour = picked.hour < 10 ? '0${picked.hour.toString()}' : picked.hour.toString();
    min = picked.minute < 10 ? '0${picked.minute.toString()}' : picked.minute.toString();
    textDate.text =
        '${_utils.getDate(DateTime.now())} (${_utils.getDay(DateTime.now())})';
    super.initState();
  }

  void getAssetInfo(String asset, int assetId) {
    setState(() {
      this.asset = asset;
      this.assetId = assetId;
    });
  }

  Widget _appbar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: Text(title, style: TextStyle(fontSize: 18)),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _iconButtonRow(),
            _costInfo(),
            SizedBox(height: 20),
            _saveButton(),
          ],
        ),
      ),
    );
  }

  Widget _costInfo() {
    return Container(
      child: Column(
        children: [
          _inputDatePicker(),
          _inputAssets(),
          _inputCategory(),
          // _inputForm('분류', textCategory, TextInputType.text),
          _inputPrice(),
          _inputForm('메모', textTitle, TextInputType.text),
        ],
      ),
    );
  }

  Widget _iconButton(String _title, int _type, Color color) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        setState(() {
          assetType = _type;
          title = _title;
        });
      },
      child: Container(
        width: size.width / 2 * 0.55,
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
                width: 1,
                color: _type == assetType ? color : Colors.black.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(5)),
        child: Center(
            child: Text(_title,
                style: TextStyle(
                    color: _type == assetType
                        ? color
                        : Colors.black.withOpacity(0.5)))),
      ),
    );
  }

  Widget _iconButtonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _iconButton('소득', 1, Colors.red),
        _iconButton('지출', 2, Colors.blue),
        _iconButton('투자', 3, Colors.green),
      ],
    );
  }

  Widget _inputForm(
      String title, TextEditingController controller, TextInputType type) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Text(title),
          SizedBox(width: 30),
          Expanded(
              child: TextFormField(
                  style: TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(10),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide:
                          BorderSide(color: Colors.black.withOpacity(0.3)),
                    ),
                  ),
                  keyboardType: type,
                  controller: controller))
        ],
      ),
    );
  }

  Widget _inputPrice() {
    return GestureDetector(
      onTap: () => showDialog(
          context: context,
          builder: (context) {
            return Calculator(onPress: setPrice,);
          }),
      child: Container(
        margin: EdgeInsets.only(top: 10),
        child: Row(
          children: [
            Text('금액'),
            SizedBox(width: 30),
            Expanded(
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(width: 1, color: Colors.black.withOpacity(0.3))
                  ),
                  child: Center(
                    child: Text('${_utils.priceFormat(int.parse(price))}'),
                  ),
                )
            )
          ],
        ),
      ),
    );
  }

  Widget _inputCategory() {
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (context) {
          return _categoryDialog();
        }
      ),
      child: Container(
        margin: EdgeInsets.only(top: 10),
        child: Row(
          children: [
            Text('분류'),
            SizedBox(width: 30),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(width: 1, color: Colors.black.withOpacity(0.3))
                ),
                child: Center(
                  child: Text(category),
                ),
              )
            )
          ],
        ),
      ),
    );
  }

  Widget _inputAssets() {
    return GestureDetector(
      onTap: () => showDialog(
          context: context,
          builder: (context) {
            return AssetDialog(callback: getAssetInfo,);
          }
      ),
      child: Container(
        margin: EdgeInsets.only(top: 10),
        child: Row(
          children: [
            Text('자산'),
            SizedBox(width: 30),
            Expanded(
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(width: 1, color: Colors.black.withOpacity(0.3))
                  ),
                  child: Center(
                    child: Text(asset),
                  ),
                )
            )
          ],
        ),
      ),
    );
  }

  Widget _inputTimePicker() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.black.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(5)),
      child: GestureDetector(
          onTap: () {
            showTimePicker(
              context: context,
              initialTime: picked,
              builder: (BuildContext context, Widget child) {
                return MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(alwaysUse24HourFormat: true),
                  child: child,
                );
              },
            ).then((value) {
              if (value != null)
                setState(() {
                  picked = value;
                  hour = picked.hour < 10
                      ? '0${picked.hour.toString()}' : picked.hour.toString();
                  min = picked.minute < 10
                      ? '0${picked.minute.toString()}' : picked.minute.toString();
                });
            });
          },
          child: Text(
            "$hour : $min",
            textAlign: TextAlign.center,
          )),
    );
  }

  Widget _inputDatePicker() {
    return Container(
      margin: EdgeInsets.only(top: 40),
      child: Row(children: [
        Text('날짜'),
        SizedBox(width: 30),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              border:
                  Border.all(width: 1, color: Colors.black.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(5)),
          child: GestureDetector(
              onTap: () {
                showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1990),
                        lastDate: DateTime(2100))
                    .then((value) {
                  setState(() {
                    now = value;
                    textDate.text =
                        '${_utils.getDate(now)} (${_utils.getDay(now)})';
                  });
                });
              },
              child: Container(
                child: Text(textDate.text, style: TextStyle(fontSize: 16)),
              )),
        ),
        SizedBox(width: 10),
        _inputTimePicker(),
      ]),
    );
  }

  Widget _saveButton() {
    return TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
        ),
        onPressed: () {
          var date = DateFormat('yyyyMMdd').format(now).toString();
          var hour = picked.hour < 10 ? '0${picked.hour}' : picked.hour;
          var min = picked.minute < 10 ? '0${picked.minute}' : picked.minute;
          var time = '$hour$min';

          if(assetId == -1){
            Get.defaultDialog(
              barrierDismissible: true,
              title: '',
              textCancel: '확인',
              content: Center(
                child: Text('자산을 선택해 주세요.'),
              )
            );
            return;
          }

          if(categoryId == -1){
            Get.defaultDialog(
                barrierDismissible: true,
                title: '',
                textCancel: '확인',
                content: Center(
                  child: Text('카테고리를 선택해 주세요.'),
                )
            );
            return;
          }

          if(price.isEmpty || price == '0'){
            Get.defaultDialog(
                barrierDismissible: true,
                title: '',
                textCancel: '확인',
                content: Center(
                  child: Text('금액을 입력해 주세요.'),
                )
            );
            return;
          }

          if(textTitle.text.isEmpty){
            Get.defaultDialog(
                barrierDismissible: true,
                title: '',
                textCancel: '확인',
                content: Center(
                  child: Text('메모를 입력해 주세요.'),
                )
            );
            return;
          }

          AssetContent assetContent = AssetContent(
              title: textTitle.text,
              price: int.parse(price),
              assetId: assetId,
              assetType: assetType,
              date: date + time,
              category: categoryId,);
          _costController.insertCostContent(assetContent);
        },
        child: Text(
          '저장하기',
          style: TextStyle(color: Colors.white),
        ));
  }

  Widget _categoryDialog() {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 1,
        backgroundColor: Colors.white,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: Theme.of(context).primaryColor,
                ),
                child: Center(
                    child: Text('카테고리',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)
                    )
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: 5),
                  child: ListView.separated(
                    itemCount: _costController.categoryList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            categoryId = _costController.categoryList[index].id;
                            category = _costController.categoryList[index].name;
                          });
                          Get.back();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                          child: Text('${_costController.categoryList[index].name} '),
                        ),
                      );
                    },
                    separatorBuilder: (context, _) {
                      return Divider();
                    },
                  ),
                )
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(onPressed: () => Get.back(), child: Text('취소')),
                  // TextButton(onPressed: () {}, child: Text('추가')),
                ],
              )
            ],
          ),
        ));
  }

  void setPrice(String price) {
    print(price);
    setState(() {
      this.price = price;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appbar(),
      body: _body(),
    );
  }
}

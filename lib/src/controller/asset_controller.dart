import 'package:get/get.dart';

class AssetController extends GetxController {
  RxList assetList = [
    {'title': '수입', 'money': 3500000, 'id': 1},
    {'title': '지출', 'money': -750000, 'id': 2},
    {'title': '잔여할부', 'money': -155000, 'id': 3},
  ].obs;

  RxInt total = 0.obs;

  @override
  void onInit() {
    calcTotal();
    super.onInit();
  }

  void calcTotal() {
    int result = 0;
    for(var asset in assetList) {
      result += asset['money'];
    }
    assetList.add({'title': '잔액', 'money': result, 'id': 4});
    total(result);
  }
}
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UtilController extends GetxController {
  // 날짜 (현재일 기본값)
  Rx<DateTime> _date = DateTime.now().obs;
  DateTime get date => _date.value;

  @override
  void onInit() {
    super.onInit();
  }

  // 월 변경
  void changeDate(int count) {
    int daysInMonth(DateTime date){
      var firstDayThisMonth = new DateTime(date.year, date.month, date.day);
      var firstDayNextMonth = new DateTime(firstDayThisMonth.year, firstDayThisMonth.month + count, firstDayThisMonth.day);
      return firstDayNextMonth.difference(firstDayThisMonth).inDays;
    }

    _date( _date.value.add(Duration(days: daysInMonth(_date.value))) );
  }

  void changeDateSelected(String date) {
    date = date.replaceAll('.', '');
    int year = int.parse(date.substring(0,4));
    int month = int.parse(date.substring(4,6));
    DateTime dateTime = DateTime(year, month, 1);

    _date(dateTime);
  }
}
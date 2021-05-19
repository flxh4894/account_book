import 'package:intl/intl.dart';

class CommonUtils {

  final formatCurrency = new NumberFormat.simpleCurrency(locale: 'ko-KR', name: '', decimalDigits: 0);

  DateTime convertDateTime(String year, String month, String day){
    return DateTime(int.parse(year), int.parse(month), int.parse(day));
  }

  String getDate (DateTime now){
    return DateFormat('yyyy.MM.dd').format(now).toString();
  }

  String getYearMonth (DateTime now){
    return DateFormat('yyyy.MM').format(now).toString();
  }

  String getDateDbType(DateTime now) {
    return DateFormat('yyyyMMdd').format(now).toString();
  }

  String getDay (DateTime now) {
    switch(now.weekday){
      case 1:
        return '월요일';
      case 2:
        return '화요일';
      case 3:
        return '수요일';
      case 4:
        return '목요일';
      case 5:
        return '금요일';
      case 6:
        return '토요일';
      case 7:
        return '일요일';
    }

    return null;
  }

  String substringDate(String date){
    return date.substring(4,6) + "/" + date.substring(6,8);
  }

  String convertDateFormat(String date){
    return date.replaceAll('.', '').substring(0,8);
  }

  String priceFormat(int price) {
    return '${formatCurrency.format(price)} 원';
  }

  String setComma(int amount) {
    return formatCurrency.format(amount);
  }

}
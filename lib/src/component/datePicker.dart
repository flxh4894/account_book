import 'package:accountbook/src/controller/util_controller.dart';
import 'package:accountbook/src/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DatePickerComponent extends StatefulWidget {

  final DateTime now;
  final double fontSize;
  final Color fontColor;
  DatePickerComponent({@required this.now, @required this.fontColor, this.fontSize });

  @override
  _DatePickerComponentState createState() => _DatePickerComponentState();
}

class _DatePickerComponentState extends State<DatePickerComponent> {
  final CommonUtils _utils = CommonUtils();
  final UtilController _utilController = Get.find<UtilController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1990),
              lastDate: DateTime(2100),
              builder: (BuildContext context, Widget child) {
                return Theme(
                  data: ThemeData.light().copyWith(
                    colorScheme: ColorScheme.light(
                        primary: const Color(0xff00C78C),
                    ),
                  ),
                  child: child,
                );
              },
          ).then((value) {
            if(value != null) {
              _utilController.changeDateSelected(_utils.getYearMonth(value));
            }
          });
        },
        child: Container(
          child: Text( _utils.getYearMonth(_utilController.date), style: TextStyle(
              fontSize: widget.fontSize,
              color: widget.fontColor,
              fontWeight: FontWeight.bold) ),
        )
      ),
    );
  }
}

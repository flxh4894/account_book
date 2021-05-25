import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:math_expressions/math_expressions.dart';

import 'my_button.dart';

class Calculator extends StatefulWidget {

  final Function onPress;
  Calculator({this.onPress});

  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  var userInput = '';
  var answer = '';
  var lastTap = '';

// Array of button
  final List<String> buttons = [
    'C',
    'x',
    '/',
    'DEL',
    '7',
    '8',
    '9',
    '-',
    '4',
    '5',
    '6',
    '+',
    '1',
    '2',
    '3',
    '=',
    '00',
    '0',
    '.',
    '완료',
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 1,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            IconButton(icon: Icon(Icons.close), onPressed: () => Get.back()),
            Container(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(20),
                      alignment: Alignment.centerRight,
                      child: Text(
                        userInput,
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(15),
                      alignment: Alignment.centerRight,
                      child: Text(
                        answer,
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ]),
            ),
            Container(
              color: Colors.black.withOpacity(0.1),
              child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: buttons.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4),
                  itemBuilder: (BuildContext context, int index) {
                    // 삭제 버튼
                    if (index == 0) {
                      return MyButton(
                        buttontapped: () {
                          setState(() {
                            userInput = '';
                            answer = '0';
                          });
                        },
                        buttonText: buttons[index],
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                      );
                    }

                    // 삭제 버튼
                    else if (index == 3) {
                      return MyButton(
                        buttontapped: () {
                          setState(() {
                            userInput =
                                userInput.substring(0, userInput.length - 1);
                          });
                        },
                        buttonText: buttons[index],
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                      );
                    }

                    // 계산버튼
                    else if (index == 15) {
                      return MyButton(
                        buttontapped: () {
                          setState(() {
                            equalPressed();
                          });
                        },
                        buttonText: buttons[index],
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                      );
                    }

                    // 완료버튼
                    else if (index == 19) {
                      return MyButton(
                        buttontapped: () {
                          setState(() {
                            equalPressed();
                          });
                          widget.onPress(answer);
                          Get.back();
                        },
                        buttonText: buttons[index],
                        color: Colors.red,
                        textColor: Colors.white,
                      );
                    }

                    // 다른 버튼들
                    else {
                      return MyButton(
                        buttontapped: () {
                          setState(() {
                            if(isOperator(lastTap) && isOperator(buttons[index])){
                              userInput = userInput.substring(0, userInput.length-1);
                              userInput += buttons[index];
                            } else {
                              userInput += buttons[index];
                            }
                            lastTap = buttons[index];
                          });
                        },
                        buttonText: buttons[index],
                        color: isOperator(buttons[index])
                            ? Theme.of(context).primaryColor
                            : Colors.white,
                        textColor: isOperator(buttons[index])
                            ? Colors.white : Colors.black,
                      );
                    }
                  }
                ),
            ),
          ],
        ),
      ),
    );
  }

  bool isOperator(String x) {
    if (x == '/' || x == 'x' || x == '-' || x == '+' || x == '=') {
      return true;
    }
    return false;
  }

  void equalPressed() {
    String finalUserInput = userInput;
    finalUserInput = userInput.replaceAll('x', '*');

    Parser p = Parser();
    Expression exp = p.parse(finalUserInput);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);
    eval = eval.roundToDouble();

    if(eval == eval.toInt())
      answer = eval.toInt().toString();
    else
      answer = eval.toString();
  }
}

import 'package:flutter/material.dart';

class AppbarComponent extends StatelessWidget {

  final String title;

  const AppbarComponent({@required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      title: Text(title),
    );
  }
}

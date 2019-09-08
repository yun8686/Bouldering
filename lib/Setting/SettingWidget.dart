import 'dart:io';

import 'package:flutter/material.dart';

class SettingWidget extends StatelessWidget {
  Color color = Colors.red;
  String title = "Setting";

  SettingWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 25,
          ),
        ),
      ),
    );
  }
}
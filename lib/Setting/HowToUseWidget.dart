import 'dart:io';

import 'package:flutter/material.dart';

class HowToUseWidget extends StatelessWidget {
  Color color = Colors.white;
  String title = "Setting";

  HowToUseWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('使い方ガイド'),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class LocationSettingWidget extends StatelessWidget {
  LocationSettingWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('位置情報'),
      ),
    );
  }
}
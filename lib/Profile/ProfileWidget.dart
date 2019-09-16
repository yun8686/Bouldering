import 'package:bouldering_sns/Home/Widgets/FavolitGymListWidget.dart';
import 'package:bouldering_sns/Home/Widgets/NearGymListWidget.dart';
import 'package:bouldering_sns/Home/Widgets/UserPanelWidget.dart';
import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('プロフィール'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10.0),
            height: 240.0,
            child: UserPanelWidget(),
          ),
          Text("自己紹介文"),
          Text("登ったグレード"),
          Text("地域"),
          Text("SNS連携"),

        ],
      ),
    );
  }
}



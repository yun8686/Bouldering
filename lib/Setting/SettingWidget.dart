
import 'package:bouldering_sns/GymDetail/ProblemMakeWidget.dart';
import 'package:bouldering_sns/Setting/ContactWidget.dart';
import 'package:bouldering_sns/Setting/HowToUseWidget.dart';
import 'package:bouldering_sns/Setting/LocationSettingWidget.dart';
import 'package:bouldering_sns/Setting/NoticeSettingWidget.dart';
import 'package:bouldering_sns/Setting/PrivacyPolicyWidget.dart';
import 'package:bouldering_sns/Setting/TermsOfServiceWidget.dart';
import 'package:bouldering_sns/camera/camera.dart';
import 'package:flutter/material.dart';

class SettingWidget extends StatelessWidget {
  Color color = Colors.white;
  String title = "Setting";

  SettingWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      body: _buildList(context),
    );
  }

  Widget _buildList(BuildContext context) => ListView(
    children: [
      _tile('使い方ガイド', context, new HowToUseWidget()),
      _tile('通知設定', context, new NoticeSettingWidget()),
      _tile('位置情報', context, new LocationSettingWidget()),
      Divider(),
      _tile('利用規約', context, new TermsOfServiceWidget()),
      _tile('お問い合わせ', context, new ContactWidget()),
      _tile('プライバシーポリシー', context, new PrivacyPolicyWidget()),
      Divider(),
      _tile('カメラテスト', context, new CameraWidget()),
      _tile('課題投稿画面テスト', context, new ProblemMakeWidget()),
    ],
  );

  ListTile _tile(String title,BuildContext context, Widget widget) => ListTile(
    title: Text(title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20,
        )),
    onTap: (){
      Navigator.push(context,
          new MaterialPageRoute<Null>(
            builder: (BuildContext context) => widget,
          ));
    },
  );
}
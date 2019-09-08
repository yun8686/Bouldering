
import 'package:bouldering_sns/Setting/HowToUseWidget.dart';
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

  //TODO: 各ウィジェット作る
  Widget _buildList(BuildContext context) => ListView(
    children: [
      _tile('使い方ガイド', context, new HowToUseWidget()),
      _tile('通知設定', context, new HowToUseWidget()),
      _tile('位置情報', context, new HowToUseWidget()),
      Divider(),
      _tile('利用規約', context, new HowToUseWidget()),
      _tile('お問い合わせ', context, new HowToUseWidget()),
      _tile('プライバシーポリシー', context, new HowToUseWidget()),
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
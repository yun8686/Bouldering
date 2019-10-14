import 'package:flutter/material.dart';

class VerifyModal{
  static void openModal(BuildContext context){
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return _VerifyWidget();
        },
        fullscreenDialog: true,
    ));
  }
}

class _VerifyWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        body:Column(
        children: <Widget>[
          Text("この機能を利用するには会員登録が必要です"),
          TextField(),
        ],
      ),
    ),
    );
  }

}
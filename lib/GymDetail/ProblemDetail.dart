import 'package:bouldering_sns/GymDetail/GymList.dart';
import 'package:flutter/material.dart';

class ProblemDetailWidget extends StatelessWidget {
  String name, title, placeId;

  ProblemDetailWidget({this.name,this.title, this.placeId});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: <Widget>[
            GymHeaderCard(title: this.title, placeId:this.placeId),
            _PictureArea(),
            _DetailArea(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.edit),
          onPressed: (){},
        ),
      ),
    );
  }
}



class _PictureArea extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Image(
      image: AssetImage('assets/backgroundimages/login.jpg'),
      fit: BoxFit.fill,
    );
  }
}

class _DetailArea extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return
    Column(
      children: <Widget>[
        Wrap(
          spacing: 8.0,
          children: <Widget>[
            Chip(
              label: Text('カチ'),
            ),
            Chip(
              label: Text('スラブ'),
            ),
            Chip(
              label: Text('足自由'),
            )
          ],
        ),
        Text("色"),
        Text("作成者"),
        Text("コメント"),
      ],
    );
  }
}
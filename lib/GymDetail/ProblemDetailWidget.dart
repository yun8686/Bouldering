import 'package:bouldering_sns/GymDetail/GymGradeListWidget.dart';
import 'package:flutter/material.dart';

class ProblemDetailWidget extends StatelessWidget {
  String name, title, placeId;

  ProblemDetailWidget({this.name,this.title, this.placeId});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: <Widget>[
            Stack(children: <Widget>[
              _PictureArea(),
              Row(children: <Widget>[
                IconButton(icon: Icon(Icons.arrow_back, color: Colors.white.withOpacity(0.7)), onPressed: () {
                  Navigator.pop(context);
                })
              ]),
            ]),
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
    Size size = MediaQuery.of(context).size;
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
        Text("コメントコメントコメントコメントコメントコメントコメントコメントコメントコメントコメント"),
        _CaptureInformation(),
        _CommentInformation(),
      ],
    );
  }
}

class _CaptureInformation extends StatefulWidget{
  _CaptureInformation({Key key}) : super(key: key);
  @override
  _CaptureInformationState createState() => _CaptureInformationState();
}
class _CaptureInformationState extends State<_CaptureInformation>{
  bool isOpen = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Widget> columns = List<Widget>();
    columns.add(
      GestureDetector(
        child: Container(
          width: size.width,
          child: Text("攻略情報${!this.isOpen?"を見る":""}"),
          decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey))), padding: EdgeInsets.only(top: 8.0, left: 8.0, bottom: 8.0)),
        onTap: (){
          setState(() {
            this.isOpen = !this.isOpen;
          });
        },
      )
    );
    if(this.isOpen){
      columns.add(
        Column(children: <Widget>[
          Text("攻略攻略攻略攻略攻略攻略攻略攻略攻略攻略攻略攻略"),
          Text("攻略攻略攻略攻略攻略攻略攻略攻略攻略攻略攻略攻略"),
          Text("攻略攻略攻略攻略攻略攻略攻略攻略攻略攻略攻略攻略"),
        ])
      );
    }
    return Column(
      children: columns,
    );
  }
}


class _CommentInformation extends StatefulWidget{
  _CommentInformation({Key key}) : super(key: key);
  @override
  _CommentInformationState createState() => _CommentInformationState();

}
class _CommentInformationState extends State<_CommentInformation>{
  bool isOpen = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Widget> columns = List<Widget>();
    columns.add(
        GestureDetector(
          child: Container(width: size.width, child: Text("コメント${!this.isOpen?"を見る":""}"), decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey))), padding: EdgeInsets.only(top: 8.0, left: 8.0, bottom: 8.0)),
          onTap: (){
            setState(() {
              this.isOpen = !this.isOpen;
            });
          },
        )
    );
    if(this.isOpen){
      columns.add(
        Column(children: <Widget>[
          commentRow(),
          commentRow(),
          commentRow(),
        ]),
      );
    }
    return Column(
      children: columns,
    );
  }


  Widget commentRow(){
    return Container(
      padding: EdgeInsets.all(4.0),
      child: Column(
        children: <Widget>[
          Row(children: <Widget>[
            CircleAvatar(backgroundImage: NetworkImage("https://booth.pximg.net/c3d42cdb-5e97-43ff-9331-136453807f10/i/616814/d7def86b-1d95-4f2d-ad9c-c0c218e6a533_base_resized.jpg")),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("山田太郎"),
                Text("2019/11/11 12:00"),
              ],
            )
          ]),
          Text("なかなかクリアできない課題だったのでとても助かりました！助かりませんでした！"),
          Padding(padding: EdgeInsets.only(left :12.0, top: 4.0, bottom: 4.0, right: 4.0),
              child: Row(
                  children: <Widget>[
                    SizedBox(
                        width: 18.0, height: 18.0,
                        child: IconButton(icon: Icon(Icons.thumb_up, size: 18.0), padding: EdgeInsets.all(0.0))),
                    Expanded(child: Text("1200")),
                    GestureDetector(
                      child: Text("返信", textAlign: TextAlign.end),
                      onTap: (){
                        print("tappu");
                      },
                    ),
                  ])),
          Divider(color: Colors.grey,),
        ],
      ),
    );
  }

}
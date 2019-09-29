import 'package:bouldering_sns/Model/Gym/Problem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:meta/meta.dart';

class ProblemMakeWidget extends StatefulWidget {
  String gymId, gradeId;

  ProblemMakeWidget({@required this.gymId, @required this.gradeId});
  @override
  State<StatefulWidget> createState() {
    return _ProblemMakeWidgetState(gymId: gymId, gradeId: gradeId);
  }
}
class _ProblemMakeWidgetState extends State<ProblemMakeWidget>{
  String title = "", comment = "";

  String gymId, gradeId;
  _ProblemMakeWidgetState({this.gymId, this.gradeId});
  @override
  Widget build(BuildContext context) {
    print("build");
    return  SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text("課題登録"),
              actions: <Widget>[
                FlatButton(
                  textColor: Colors.white,
                  onPressed: () {
                    if(true){
                      print("ok");
                      Problem(title: this.title, comment: comment, gym: gymId).create();
                    }else{
                      print("ng");
                    }
                  },
                  child: Text("次へ"),
                  shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
                ),
              ],
            ),
            body: (
                //key: _formKey,child:
                Container(
                  padding: EdgeInsets.all(4.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Image(image: AssetImage('assets/backgroundimages/login.jpg'), width: 80.0, height:80.0),
                          Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '課題'
                                ),
                                onChanged: (value){
                                  title = value;
                                },
                              )
                          )
                        ],
                      ),
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
                      _scrollableTextField(
                        onChanged: (value){
                          this.comment = value.replaceAll(RegExp(r'[\n\r]'), "\\n");
                          print("trom " + this.comment + " trom");
                        },
                      ),
                    ],
                  ),
                )))
    );
  }
}



class _scrollableTextField extends StatefulWidget {
  Function(String) onChanged;
  _scrollableTextField({this.onChanged});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _scrollableTextFieldState(onChanged: this.onChanged);
  }
}
class _scrollableTextFieldState extends State<_scrollableTextField>{
  Function(String) onChanged;
  _scrollableTextFieldState({this.onChanged});
  @override
  Widget build(BuildContext context) {
    return Expanded(child:ListView(
      children: [
        Container(
          margin: const EdgeInsets.all(10.0),
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          child: TextField(
            decoration: InputDecoration(border: InputBorder.none, hintText: "コメントを入力"),
            //テキストフォーム下の下線
            keyboardType: TextInputType.multiline,
            minLines: 3,
            maxLines: null,
            textAlign: TextAlign.left,
            onChanged: this.onChanged,
          ),
        ),
      ],
    ));
  }
}
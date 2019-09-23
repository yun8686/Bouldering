import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ProblemMakeWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProblemMakeWidgetState();
  }
}
class _ProblemMakeWidgetState extends State<ProblemMakeWidget>{
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
                                  )
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
                      _scrollableTextField(),
                    ],
                  ),
                )))
    );
  }
}



class _scrollableTextField extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _scrollableTextFieldState();
  }
}
class _scrollableTextFieldState extends State<_scrollableTextField>{
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
          ),
        ),
      ],
    ));
  }
}
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';

class ChatWidget extends StatefulWidget {
  String user = "";
  ChatWidget(this.user);
  @override
  ChatWidgetState createState() => ChatWidgetState(this.user);
}

class ChatWidgetState extends State<ChatWidget> {
  String user = "";
  ChatWidgetState(this.user);

  @override
  Widget build(BuildContext context) {

    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    double px = 1 / pixelRatio;
    this.styleSomebody = BubbleStyle(
      nip: BubbleNip.leftTop,
      color: Colors.white,
      elevation: 1 * px,
      margin: BubbleEdges.only(top: 8.0, right: 50.0),
      alignment: Alignment.topLeft,
    );
    this.styleMe = BubbleStyle(
      nip: BubbleNip.rightTop,
      color: Color.fromARGB(255, 225, 255, 199),
      elevation: 1 * px,
      margin: BubbleEdges.only(top: 8.0, left: 50.0),
      alignment: Alignment.topRight,
    );

    return Scaffold(
        appBar: AppBar(
            title: Text(this.user),
            automaticallyImplyLeading: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            )),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                      child: Container(
                          child: ListView(
                            children: createChatRows(),
                  ))),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                        child: Container(
                          color: Colors.white,
                          child: Row(
                            children: <Widget>[
                              Flexible(
                                child: TextField(minLines: 1, maxLines: 10),
                              ),
                              Material(
                                  child: IconButton(
                                icon: Icon(Icons.send),
                              )),
                            ],
                          ),
                        ),
                        padding: EdgeInsets.all(5.0)
                    ),
                  )
              ],
        )
    );
  }

  List<Widget> createChatRows(){
    List<Widget> chatRows = List<Widget>();
    for(int i=1;i<=50;i++){
      chatRows.add(createChatRow("発言" + i.toString() ,  i%3==0));
    }
    return chatRows;
  }

  BubbleStyle styleSomebody, styleMe;
  Widget createChatRow(String text, bool isMe){
    List<Widget> row = List<Widget>();
    if(!isMe){
      row.add(CircleAvatar(
        backgroundImage: new NetworkImage(
            "https://booth.pximg.net/c3d42cdb-5e97-43ff-9331-136453807f10/i/616814/d7def86b-1d95-4f2d-ad9c-c0c218e6a533_base_resized.jpg"),
      ));
    }
    row.add(Expanded(child: Bubble(style: isMe?this.styleMe:this.styleSomebody, child: Text(text))));
    return Row(
      children: row,
    );
  }

}

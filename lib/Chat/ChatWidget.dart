import 'dart:io';

import 'package:flutter/material.dart';

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
    return Scaffold(
        appBar: AppBar(
            title: Text(this.user),
            automaticallyImplyLeading: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            )),
        body: Column(children: <Widget>[
          Expanded(
            child: Container(
              color: Colors.black12,
              child: ListView(
                children: createChatRows(),
              ),
            ),
          ),
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
                padding: EdgeInsets.all(5.0)),
          )
        ]));
  }

  List<Widget> createChatRows(){
    List<Widget> chatRows = List<Widget>();
    for(int i=1;i<=50;i++){
      chatRows.add(createChatRow("発言" + i.toString()));
    }
    return chatRows;
  }
  Widget createChatRow(String text){
    return Row(
      children: <Widget>[
        CircleAvatar(
          backgroundImage: new NetworkImage(
              "https://booth.pximg.net/c3d42cdb-5e97-43ff-9331-136453807f10/i/616814/d7def86b-1d95-4f2d-ad9c-c0c218e6a533_base_resized.jpg"),
        ),
        Text(text)
      ],
    );
  }
}

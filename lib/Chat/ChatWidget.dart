import 'dart:io';
import 'dart:ui';

import 'package:bouldering_sns/Model/Chat/Chat.dart';
import 'package:bouldering_sns/Model/User/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';

class ChatWidget extends StatefulWidget {
  User rightUser, leftUser;
  Chat chat;
  ChatWidget({this.rightUser, this.leftUser}){
    chat = Chat(
      rightUser: this.rightUser,
      leftUser: this.leftUser,
    );
  }
  @override
  ChatWidgetState createState() => ChatWidgetState(chat:chat);
}

class ChatWidgetState extends State<ChatWidget> {
  Chat chat;
  ChatWidgetState({this.chat});

  String message = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
            title: Text(this.chat.leftUser.displayName),
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
                          child: createChatRows(),
                  )),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                        child: Container(
                          color: Colors.white,
                          child: Row(
                            children: <Widget>[
                              Flexible(
                                child: TextField(minLines: 1, maxLines: 10, onChanged: (value){
                                  this.message = value;
                                },),
                              ),
                              Material(
                                  child: IconButton(
                                    icon: Icon(Icons.send),
                                    onPressed: (){
                                      chat.sendChat(message);
                                    },
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

  StreamBuilder<QuerySnapshot> createChatRows(){
    return StreamBuilder<QuerySnapshot>(
      stream: chat.getChatStream(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(!snapshot.hasData || snapshot.data.documents.length == 0){
          return const Text('Loading...');
        }else{
          List<Widget> list = List<Widget>();
          snapshot.data.documents.forEach((document){
            if(document.data["creator"] == chat.leftUser.key){
              list.add(createChatRow(document.data["message"], false));
            }else{
              list.add(createChatRow(document.data["message"], true));
            }
          });
          return ListView(children: list.reversed.toList());
        }
      },
    );
  }

  BubbleStyle styleSomebody, styleMe;
  Widget createChatRow(String text, bool isMe){
    List<Widget> row = List<Widget>();
    if(!isMe){
      row.add(CircleAvatar(
        backgroundImage: NetworkImage(
            "https://booth.pximg.net/c3d42cdb-5e97-43ff-9331-136453807f10/i/616814/d7def86b-1d95-4f2d-ad9c-c0c218e6a533_base_resized.jpg"),
      ));
    }
    if(isMe){
      row.add(Expanded(child: Bubble(style: this.styleMe, child: Text(text))));
    }else{
      row.add(Expanded(child: Bubble(style: this.styleSomebody, child: Text(text))));
    }
    return Row(
      children: row,
    );
  }

}

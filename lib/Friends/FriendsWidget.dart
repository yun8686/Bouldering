import 'dart:io';

import 'package:bouldering_sns/Chat/ChatWidget.dart';
import 'package:flutter/material.dart';

class FriendsWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new FriendsWidgetState();
}

class FriendsWidgetState extends State<FriendsWidget> {
  bool showSearchArea = false;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
                title: Text("トーク"),
                actions: <Widget>[
                  IconButton(
                    // 検索テキスト開閉
                    icon: Icon(Icons.search),
                    onPressed: () {
                      this.setState(() {
                        this.showSearchArea = !this.showSearchArea;
                      });
                    },
                  )
                ],
                bottom: TabBar(tabs: <Widget>[
                  Tab(text: "Friends"),
                  Tab(text: "near by"),
                ])),
            body: TabBarView(
              children: <Widget>[
                Center(child: Column(children: getFriendsWidgets())),
                Center(child: Column(children: getNearByWidgets())),
              ],
            )));
  }

  List<Widget> getFriendsWidgets() {
    List<Widget> widgets = new List<Widget>();
    if (this.showSearchArea) widgets.add(searchAreaText());
    widgets.add(Expanded(
      child: Container(
          child: RefreshIndicator(
              onRefresh: _onRefresh,
              child: new ListView(
                children: userList("たかしくん"),
              ))),
    ));
    return widgets;
  }

  List<Widget> getNearByWidgets() {
    List<Widget> widgets = new List<Widget>();
    if (this.showSearchArea) widgets.add(searchAreaText());
    widgets.add(Expanded(
      child: Container(
          child: RefreshIndicator(
              onRefresh: _onRefresh,
              child: new ListView(
                children: userList("けんじくん"),
              ))),
    ));
    return widgets;
  }

  List<Widget> userList(String name) {
    List<Widget> users = new List<Widget>();
    for (int i = 1; i <= 100; i++) {
      users.add(new ListTile(
        leading: new CircleAvatar(
          backgroundImage: new NetworkImage(
              "https://booth.pximg.net/c3d42cdb-5e97-43ff-9331-136453807f10/i/616814/d7def86b-1d95-4f2d-ad9c-c0c218e6a533_base_resized.jpg"),
        ),
        title: new Text(name + i.toString()),
        onTap: () {
          Navigator.push(
              context,
              new MaterialPageRoute<Null>(
                builder: (BuildContext context) =>
                    new ChatWidget(name + i.toString()),
              ));
        },
      ));
    }
    return users;
  }

  //
  Future<void> _onRefresh() async {
    setState(() {
      this.showSearchArea = true;
    });
  }

  TextField searchAreaText() {
    return new TextField(
        maxLines: 1,
        decoration: const InputDecoration(
          hintText: "search..",
          labelText: "search",
        ));
  }
}

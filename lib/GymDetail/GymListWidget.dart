import 'dart:io';

import 'package:bouldering_sns/GymDetail/Widgets/FavoriteGymListWidget.dart';
import 'package:bouldering_sns/GymDetail/Widgets/NearGymListWidget.dart';
import 'package:flutter/material.dart';

class GymListWidget extends StatefulWidget {
  @override
  State<GymListWidget> createState() => new GymListWidgetState();
}

class GymListWidgetState extends State<GymListWidget> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
                title: Text("課題"),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () {
                    },
                  )
                ],
                bottom: TabBar(tabs: <Widget>[
                  Tab(text: "近くのジム"),
                  Tab(text: "お気に入りのジム"),
                ])),
            body: TabBarView(
              children: <Widget>[
                NearGymListWidget(key: PageStorageKey(1)),
                FavoriteGymListWidget(key: PageStorageKey(2)),
              ],
            )
        )
    );
  }

  Widget getSearchArea(){
    return Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        child: TextField(
          decoration: InputDecoration(
              hintText: "検索",
              filled: true,
              border: InputBorder.none,
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: (){},
              )
          ),
        )
    );
  }
}

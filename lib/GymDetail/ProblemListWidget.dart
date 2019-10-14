import 'package:bouldering_sns/GymDetail/ProblemDetailWidget.dart';
import 'package:bouldering_sns/GymDetail/ProblemMakeWidget.dart';
import 'package:bouldering_sns/Model/Gym/Grade.dart';
import 'package:bouldering_sns/Model/Gym/Problem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ProblemListWidget extends StatelessWidget {
  Grade grade;
  ProblemListWidget({this.grade}){
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text(grade.name)),
        body: FutureBuilder(
          future: Problem.getGradeProblemList(grade),
          builder: (BuildContext context, AsyncSnapshot<List<Problem>> snapshot) {
            if (snapshot.hasError)
              return Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting: return new Text('Loading...');
              default:
                if(snapshot.data.length == 0){
                  return Text('課題がありません。');
                }else{
                  return ListView(
                    children: snapshot.data.map((Problem problem) {
                      return _ProblemListTile(name: problem.title);
                    }).toList().cast(),
                  );
                }
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute<Null>(
                  fullscreenDialog: true,
                    builder: (BuildContext context) =>
                        ProblemMakeWidget()));
          },
        ),
      ),
    );
  }
}

class _ProblemListTile extends StatelessWidget {
  String name;
  _ProblemListTile({this.name});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      child: Card(
        child: Row(
          children: <Widget>[
            Container(
              height: 120,
              width: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/backgroundimages/login.jpg'),fit: BoxFit.cover)
              ),
            ),
            Padding(padding: EdgeInsets.only(left: 10.0), child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
              Text(this.name,
                  style:
                      TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400)),
              Text("作成者:"),
              Text("2019/11/11"),
            ])),
            Expanded(
                child: Padding(padding: EdgeInsets.only(right: 10.0),child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Icon(Icons.favorite, color: Colors.redAccent), // 3.1.1
                Container(
                  // 3.1.2
                  child: Text(
                    "99",
                    style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.w400),
                  ),
                )
              ],
            )))
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            CupertinoPageRoute<Null>(
                builder: (BuildContext context) =>
                    ProblemDetailWidget(name: name)));
      },
    );
  }
}

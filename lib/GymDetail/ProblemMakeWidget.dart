import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProblemMakeWidget extends StatefulWidget {
  ProblemMakeWidget();
  @override
  State<StatefulWidget> createState() {
    return _ProblemMakeWidgetState();
  }
}

class _ProblemMakeWidgetState extends State<ProblemMakeWidget> {
  String title = "", comment = "";

  _ProblemMakeWidgetState();
  @override
  Widget build(BuildContext context) {
    print("build");
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("課題作成"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: (){
                  print("tap");
                },
                child: Container(
                  color: Colors.grey,
                  width: double.infinity,
                  height: 400,
                  child: Icon(Icons.camera_alt,size: 60,color: Colors.white,),
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "課題のタイトル",
                ),
              ),   
              Text("課題中の要素"),
              Container(
                height: 60.0,
                child:ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (BuildContext context, int index){
                  return Container(
                    height: 40,
                    width: 40,
                    margin: EdgeInsets.all(8),
                    child: Image.asset('assets/level_icons/90.png'),
                  );
                })
              ),
              Container(
                height: 20.0,
                child:ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 2,
                itemBuilder: (BuildContext context, int index){
                  return Container(
                    margin: EdgeInsets.only(left: 4),
                    height: 10,
                    width: 80,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Center(
                      child: Text(index==0?"足自由":"カンテ", style: TextStyle(color: Colors.white,fontSize: 12),),
                    ),
                  );
                })
              ),
              SizedBox(height: 24.0,),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "コメント",
                ),
              ),   
            ],
          ),
        ),
      )
    );
  }
}

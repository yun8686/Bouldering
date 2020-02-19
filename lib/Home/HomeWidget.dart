import 'package:flutter/material.dart';

class HomeWidget extends StatelessWidget {
  Size size;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ホーム"),
      ),
      body: ListView.builder(
        itemCount: 3,
        itemBuilder: (BuildContext context, int index) {
          return _gymCard();
        },
      ),
    );
  }
  Widget _gymCard(){
    print("GymCard");
    return Center(
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        margin:EdgeInsets.all(12.0),
        elevation: 5,
        child: Container(
          width: double.infinity,
          height: 250,
          child: Stack(
            children:<Widget>[
              Container(
                width: double.infinity,
                child: Image.network(
                  'https://placeimg.com/640/480/any',
                  fit: BoxFit.fill,
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  padding: const EdgeInsets.only(left:10.0,top:5.0,),
                  child: Text(
                    "ボルコム新宿店",
                    style: const TextStyle(fontSize: 18,color: Colors.white),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Colors.white,
                  height: 60,
                  child: Row(
                    children: <Widget>[
                      const SizedBox(width: 8.0,),
                      CircleAvatar(
                        backgroundImage: NetworkImage('https://placeimg.com/100/100/any'),
                      ),
                      const SizedBox(width: 16.0,),
                      Expanded(child: Text("ボルコム太郎",style: TextStyle(fontSize: 18,),),),
                      Container(
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Center(child:Text("3時間前"),),
                      ),
                      const SizedBox(width: 8.0,),
                    ],
                  ),
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }
  
}

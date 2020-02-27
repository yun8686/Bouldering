import 'package:flutter/material.dart';

class GymCard{
  static Widget create(BuildContext context, {Function onTap}) {
    print("GymCard");
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          margin: EdgeInsets.all(12.0),
          elevation: 5,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage('http://via.placeholder.com/1x1'),
              ),
            ),
            height: 250,
            child: Stack(children: <Widget>[
              Container(
                decoration: bwGradation,
                child: 
              Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(
                        left: 10.0,
                        top: 5.0,
                      ),
                      child: Text(
                        "ボルコム新宿店",
                        style: const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: Row(
                      children: <Widget>[
                        Container(
                          height: 30,
                          width: 30,
                          margin: EdgeInsets.all(8),
                          child: Image.asset('assets/level_icons/w90.png'),
                        ),
                        Container(
                          height: 30,
                          width: 30,
                          margin: EdgeInsets.all(8),
                          child: Image.asset('assets/level_icons/w90.png'),
                        ),
                      ],
                    ),
                    ),
                  ],
                ),
              ),),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Colors.white,
                  height: 60,
                  child: Row(
                    children: <Widget>[
                      const SizedBox(
                        width: 8.0,
                      ),
                      CircleAvatar(
                        backgroundImage:
                            NetworkImage('https://placeimg.com/100/100/any'),
                      ),
                      const SizedBox(
                        width: 16.0,
                      ),
                      Expanded(
                        child: Text(
                          "ボルコム太郎",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Container(
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Center(
                          child: Text("3時間前"),
                        ),
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  static BoxDecoration bwGradation = BoxDecoration(
    gradient: LinearGradient(
      begin: FractionalOffset.topCenter,
      end: FractionalOffset.bottomCenter,
      colors: [
        Colors.black.withOpacity(0.9),
        Colors.black.withOpacity(0.0),
      ],
      stops: const [
        0.0,
        0.3,
      ],
    ),
  );
}
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:bouldering_sns/camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Camera App",
      theme: new ThemeData(
        primarySwatch: Colors.pink,
        primaryColor: Colors.pink,
        accentColor: Colors.redAccent,
      ),
      home: new MyImagePage(),
    );
  }
}

class MyImagePage extends StatefulWidget {
  @override
  _MyImagePageState createState() => _MyImagePageState();
}

class _MyImagePageState extends State<MyImagePage> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        title: Text("Camera App!"),
//      ),
      bottomNavigationBar: new BottomNavigationBar(
        items: [
          new BottomNavigationBarItem(
            icon: const Icon(Icons.star),
            title: new Text('Home'),
          ),
          new BottomNavigationBarItem(
            icon: const Icon(Icons.star),
            title: new Text('Task'),
          ),
          new BottomNavigationBarItem(
            icon: const Icon(Icons.star),
            title: new Text('Friends'),
          ),
          new BottomNavigationBarItem(
            icon: const Icon(Icons.star),
            title: new Text('Setting'),
          )
        ],
        unselectedItemColor: Colors.lightBlue,
        selectedItemColor: Colors.lightBlueAccent,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: _selectedIndex==1?FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: getImage,
      ):null,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void getImage() async {
    Navigator.push(
        context,
        new MaterialPageRoute<Null>(
          builder: (BuildContext context) => new CameraWidget(),
        ));
  }
}

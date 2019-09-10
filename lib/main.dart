import 'package:bouldering_sns/Authentication/AuthEntranceWedget.dart';
import 'package:bouldering_sns/Friends/FriendsWidget.dart';
import 'package:bouldering_sns/camera/camera.dart';
import 'package:bouldering_sns/Setting/SettingWidget.dart';
import 'package:bouldering_sns/SplashScreen/SplashWidget.dart';
import 'package:flutter/material.dart';
import 'Library/SharedPreferences.dart';

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashWidget(),
//        home: MyApp(),
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
  void initState() {
    // TODO: implement initState
    super.initState();
    MySharedPreferences.setFirebaseUID("OKOO").then((ok){
      print("OK: " + ok.toString());
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        title: Text("Camera App!"),
//      ),
      body: SafeArea(child: getPageWidget(_selectedIndex)) ,
      bottomNavigationBar: new BottomNavigationBar(
        items: [
          new BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            title: new Text('Home'),
          ),
          new BottomNavigationBarItem(
            icon: const Icon(Icons.assistant_photo),
            title: new Text('Task'),
          ),
          new BottomNavigationBarItem(
            icon: const Icon(Icons.chat),
            title: new Text('Friends'),
          ),
          new BottomNavigationBarItem(
            icon: const Icon(Icons.account_box),
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

  Widget getPageWidget(int idx){
    switch(idx){
      case 3:
        return SettingWidget();
      case 2:
        return FriendsWidget();
//      case 0:
//        return AuthEntranceWedget();
    }
    return SettingWidget();
  }

  void getImage() async {
    Navigator.push(
        context,
        new MaterialPageRoute<Null>(
          builder: (BuildContext context) => new CameraWidget(),
        ));
  }
}

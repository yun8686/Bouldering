import 'package:bouldering_sns/Authentication/AuthEntranceWidget.dart';
import 'package:bouldering_sns/Model/User/User.dart';
import 'package:bouldering_sns/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../Library/SharedPreferences.dart';

class SplashWidget extends StatefulWidget {

  SplashWidget({Key key}) : super(key: key);
  @override
  _SplashWidgetState createState() => _SplashWidgetState();



}

class _SplashWidgetState extends State<SplashWidget> {
  Widget afterWidget;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("initState");
    setNotification().then((instance_id)async{
      String accountMode = await MySharedPreferences.getAccountMode();
      print("accountMode: " + accountMode);
      print("instance_id: " + instance_id);
      if(accountMode == MySharedPreferences.FirstTime){
        // 未ログインユーザーの場合はログイン画面
        Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (BuildContext context) => AuthEntranceWidget(),
        ));
      }else{
        User.getLoginUser().then((User user){
          user.setNotifyId(instance_id).then((v){
            Navigator.of(context).pushReplacement(new MaterialPageRoute(
              builder: (BuildContext context) => MyApp(),
            ));
          });
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
    );
  }


  // 通知設定
  Future<String> setNotification()async{
    FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
    await _firebaseMessaging.requestNotificationPermissions();
    await _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
//      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    return await _firebaseMessaging.getToken();
  }

  Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];

    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }

    // Or do other work.
    return Future<void>.value();
  }


}
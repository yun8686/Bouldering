import 'package:bouldering_sns/Authentication/AuthEntranceWedget.dart';
import 'package:bouldering_sns/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../Library/SharedPreferences.dart';

class SplashWidget extends StatefulWidget {

  SplashWidget({Key key}) : super(key: key);
  @override
  _SplashWidgetState createState() => _SplashWidgetState();



}

class _SplashWidgetState extends State<SplashWidget> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Widget afterWidget;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("initState");
    MySharedPreferences.getFirebaseUID().then((firebaseUID){
      if(firebaseUID != null){
        // ログイン済みの場合はMyApp
        Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (BuildContext context) => MyApp(),
        ));
      }else{
        // 未ログインの場合はAuthEntrance
        Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (BuildContext context) => AuthEntranceWedget(),
        ));
      }
    });
  }

  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    print('ユーザー: $user.displayName');
    return user;
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
    );
  }


}
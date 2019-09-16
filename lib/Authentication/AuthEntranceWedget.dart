import 'package:bouldering_sns/Library/SharedPreferences.dart';
import 'package:bouldering_sns/SplashScreen/SplashWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:auto_size_text/auto_size_text.dart';

class AuthEntranceWedget extends StatefulWidget {
  AuthEntranceWedget({Key key}) : super(key: key);

  @override
  _AuthEntranceState createState() => _AuthEntranceState();
}

class _AuthEntranceState extends State<AuthEntranceWedget> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String username = 'アプリをはじめよう';

  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    setState(() {
      username = user.displayName;
    });
    await MySharedPreferences.setFirebaseUID(user.uid);
    print(username);
    await Firestore.instance.collection('users').document(user.uid).setData({
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName,
    });

    Navigator.of(context).pushReplacement(new MaterialPageRoute(
      builder: (BuildContext context) => SplashWidget(),
    ));
    return user;
  }

  Future<void> _handleSignOut() async {
    _auth.signOut();
    setState(() {
      username = 'Your name';
    });
  }

  Size size = null;
  @override
  Widget build(BuildContext context) {
    if (this.size == null) this.size = MediaQuery.of(context).size;
    return Scaffold(
//        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Stack(children: <Widget>[
          Positioned.fill(
            child: Image(
              image: AssetImage('assets/backgroundimages/login.jpg'),
              fit: BoxFit.fill,
            ),
          ),
          Container(
            width: this.size.width,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 30.0,
                maxHeight: 100.0,
              ),
              child: AutoSizeText(
                "アプリをはじめよう",
                maxLines: 1,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 40.0, color: Colors.white),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(child: LoginAreaWidget()),
              SizedBox(height: 30),
              Center(child: SNSButtonSetWidget()),
            ],
          ),
        ])
        )
    );
  }

  int id_length = 0;
  int pw_length = 0;
  final FocusNode _idFocusNode = new FocusNode();
  final FocusNode _pwFocusNode = new FocusNode();
  Widget LoginAreaWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            width: size.width * 0.7,
            height: 60,
            child: TextField(
              focusNode: _idFocusNode,
              onChanged: (text) {
                setState(() {
                  this.id_length = text.length;
                });
              },
              textInputAction: TextInputAction.next,
              onEditingComplete: () => FocusScope.of(context).requestFocus(_pwFocusNode),
              decoration: new InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                  hintText: "ID",
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: Icon(
                    Icons.check_circle,
                    color: this.id_length > 0
                        ? Colors.greenAccent
                        : Colors.transparent,
                  ),
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(40.0)))),
            )
        ),
        Container(
            width: size.width * 0.7,
            height: 60,
            child: TextField(
              focusNode: _pwFocusNode,
              obscureText: true,
              onChanged: (text) {
                setState(() {
                  this.pw_length = text.length;
                });
              },
              decoration: new InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                hintText: "PW",
                filled: true,
                fillColor: Colors.white,
                suffixIcon: Icon(
                  Icons.check_circle,
                  color: this.pw_length > 0 ? Colors.greenAccent : Colors.transparent,
                ),
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(40.0)))),
            )),
      Container(
        width: size.width*0.4,
        child:RaisedButton(
          child: Text("ログイン"),
          color: Colors.greenAccent,
          textColor: Colors.white,
          shape: StadiumBorder(),
          onPressed: (){

          },
        )
      ),
      ],
    );
  }

  Widget SNSButtonSetWidget(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SignInButton(
          Buttons.Google,
          mini: true,
          onPressed: () => _handleSignIn(),
        ),
        SizedBox(width: 16),
        SignInButton(
          Buttons.Facebook,
          mini: true,
          onPressed: () {},
        ),
        SizedBox(width: 16),
        SignInButton(
          Buttons.Twitter,
          mini: true,
          onPressed: () {},
        ),
      ],
    );
  }
}

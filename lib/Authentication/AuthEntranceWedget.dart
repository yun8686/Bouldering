import 'package:bouldering_sns/Library/SharedPreferences.dart';
import 'package:bouldering_sns/SplashScreen/SplashWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class AuthEntranceWedget extends StatefulWidget {
  AuthEntranceWedget({Key key}) : super(key: key);

  @override
  _AuthEntranceState createState() => _AuthEntranceState();
}

class _AuthEntranceState extends State<AuthEntranceWedget> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String username = 'No Login';

  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    setState(() {
      username = user.displayName;
    });
    await MySharedPreferences.setFirebaseUID(user.uid);
    print(username);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('認証'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$username',
              style: Theme.of(context).textTheme.display1,
            ),

            StreamBuilder(
                stream: _auth.onAuthStateChanged,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return MaterialButton(
                      onPressed: () => _handleSignOut(),
                      color: Colors.red,
                      textColor: Colors.white,
                      child: Text('Signout'),
                    );
                  } else {
                    return MaterialButton(
                      onPressed: () => _handleSignIn(),
                      color: Colors.white,
                      textColor: Colors.black,
                      child: Text('Login with Google'),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:bouldering_sns/Library/SharedPreferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserPanelWidget extends StatefulWidget{
  @override
  _HomePanelState createState() => _HomePanelState();
}
class _HomePanelState extends State<UserPanelWidget> {
  String displayName = "", email = "";
  @override
  void initState() {
    super.initState();
    MySharedPreferences.getFirebaseUID().then((uid) {
      Firestore.instance
          .collection("users")
          .document(uid)
          .get()
          .then((DocumentSnapshot data) {
        setState(() {
          this.displayName = data["displayName"] ?? "";
          this.email = data["email"] ?? "";
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      children: <Widget>[
        _headerContainer(),
        _MySymbolImage(),
      ],
    );
  }

  Widget _MySymbolImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Material(
            elevation: 5.0,
            shape: CircleBorder(),
            child: CircleAvatar(
                radius: 40.0,
                backgroundImage: NetworkImage(
                    "https://booth.pximg.net/c3d42cdb-5e97-43ff-9331-136453807f10/i/616814/d7def86b-1d95-4f2d-ad9c-c0c218e6a533_base_resized.jpg"))),
      ],
    );
  }
  Widget _headerContainer() {
    return Container(
      padding:
      EdgeInsets.only(top: 40.0, left: 40.0, right: 40.0, bottom: 10.0),
      child: Material(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 5.0,
        color: Colors.white,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 50.0,
            ),
            Text(
              this.displayName,
              style: Theme.of(context).textTheme.title,
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(this.email),
            SizedBox(
              height: 16.0,
            ),
            Container(
              height: 40.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: ListTile(
                      title: Text(
                        "302",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("Posts".toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12.0)),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text(
                        "10.3K",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("Followers".toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12.0)),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text(
                        "120",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("Following".toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12.0)
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

}

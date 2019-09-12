import 'package:bouldering_sns/Library/SharedPreferences.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  String displayName = "", email = "";
  Geolocator _geolocator;
  final places = new GoogleMapsPlaces(apiKey: "<GOOGLEMAP-KEY>");
  @override
  void initState() {
    super.initState();

    // GPSの準備
    _geolocator = Geolocator();
    checkPermission();

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

  void checkPermission() {
    _geolocator.checkGeolocationPermissionStatus().then((status) { print('status: $status'); });
    _geolocator.checkGeolocationPermissionStatus(locationPermission: GeolocationPermission.locationAlways).then((status) { print('always status: $status'); });
    _geolocator.checkGeolocationPermissionStatus(locationPermission: GeolocationPermission.locationWhenInUse)..then((status) { print('whenInUse status: $status'); });
    updatePosition();
  }
  List<Widget> _nearGymList = <Widget>[
    ListTile(
      leading: new CircleAvatar(
        backgroundImage: new NetworkImage(
            "https://booth.pximg.net/c3d42cdb-5e97-43ff-9331-136453807f10/i/616814/d7def86b-1d95-4f2d-ad9c-c0c218e6a533_base_resized.jpg"),
      ),
      title: new Text("↓Pull to update"),
    ),
  ];
  void updatePosition() async{
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high).timeout(new Duration(seconds: 5));
    position.latitude.toString();
    PlacesSearchResponse response = await places.searchByText("ロッククライミングジム", language: "ja", location: Location(position.latitude, position.longitude));
    _nearGymList.removeRange(0, _nearGymList.length);
    response.results.forEach((res){
      final PlacesSearchResult result = res;
      _nearGymList.add(
          ListTile(
            leading: new CircleAvatar(
              backgroundImage: new NetworkImage(
                  "https://booth.pximg.net/c3d42cdb-5e97-43ff-9331-136453807f10/i/616814/d7def86b-1d95-4f2d-ad9c-c0c218e6a533_base_resized.jpg"),
            ),
            title: new Text(result.name),
            trailing: IconButton(
                icon: Icon(Icons.map),
                onPressed: () {
                  print("mapped: " + result.placeId);
                  _launchMaps(result.placeId);
                }),
            onTap: (){print("listed");},
          )
      );
      print(result.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    print("building");
    return Scaffold(
        body: DefaultTabController(
      length: 2,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 250.0,
              floating: false,
              flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                children: <Widget>[
                  ListView(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 10.0),
                        height: 240.0,
                        child: Stack(
                          children: <Widget>[
                            _headerContainer(),
                            _MySymbolImage(),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              )),
            ),
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                TabBar(
                  tabs: [
                    Tab(text: "近いジム"),
                    Tab(text: "遠いジム"),
                  ],
                ),
              ),
              pinned: true,
            )
          ];
        },
        body: TabBarView(
          children: <Widget>[
            Center(child: Column(children: getNearGymWidgets())),
            Center(child: Column(children: getNearGymWidgets())),
          ],
        ),
      ),
    ));
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

  List<Widget> getNearGymWidgets() {
    print("getNearGymWidgets");
    List<Widget> widgets = new List<Widget>();
    widgets.add(Expanded(
      child: Container(
          child: RefreshIndicator(
              onRefresh: () async{
                await updatePosition();
                setState(() {
                  this._nearGymList = _nearGymList.map((v){return v;}).toList();
                });
              },
              child: new ListView(
                children: _nearGymList,
              ))),
    ));
    return widgets;
  }




  List<Widget> userList(String name) {
    List<Widget> users = new List<Widget>();
    for (int i = 1; i <= 100; i++) {
      users.add(new ListTile(
        leading: new CircleAvatar(
          backgroundImage: new NetworkImage(
              "https://booth.pximg.net/c3d42cdb-5e97-43ff-9331-136453807f10/i/616814/d7def86b-1d95-4f2d-ad9c-c0c218e6a533_base_resized.jpg"),
        ),
        title: new Text(name + i.toString()),
      ));
    }
    return users;
  }

  void _launchMaps(String placeId) async {
    String url = 'https://www.google.com/maps/search/?api=1&query=Google&query_place_id=' + placeId ;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch Maps';
    }
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

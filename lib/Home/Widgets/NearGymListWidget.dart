import 'dart:convert';

import 'package:bouldering_sns/Home/Widgets/GymRowData.dart';
import 'package:bouldering_sns/Library/SharedPreferences.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:url_launcher/url_launcher.dart';

class NearGymListWidget extends StatefulWidget {
  NearGymListWidget({Key key}) : super(key: key);
  @override
  _NearGymListState createState() => _NearGymListState();
}

class _NearGymListParam{
  List<Widget> _nearGymList = <Widget>[
    ListTile(
      leading: new CircleAvatar(
        backgroundImage: new NetworkImage("https://booth.pximg.net/c3d42cdb-5e97-43ff-9331-136453807f10/i/616814/d7def86b-1d95-4f2d-ad9c-c0c218e6a533_base_resized.jpg"),
      ),
      title: new Text("↓Pull to update"),
    ),
  ];
}

class _NearGymListState extends State<NearGymListWidget> {
  _NearGymListParam params = null;
  final places = new GoogleMapsPlaces(apiKey: "AIzaSyAz4vCzntcPH_mbDvBK28AIv8CFieswdT4");

  @override
  void initState() {
    super.initState();
    params = _NearGymListParam();
    // GPSの準備
    showNearGymList();
  }

  void didChangeDependencies(){
    super.didChangeDependencies();
  }

  void setNearGymList() async{
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    position.latitude.toString();
    PlacesSearchResponse response = await places.searchByText("ロッククライミングジム", language: "ja", location: Location(position.latitude, position.longitude));
    List<GymRowData> nearGymList = List<GymRowData>();
    response.results.forEach((res) {
      final PlacesSearchResult result = res;
      GymRowData gymRowData = GymRowData(name: result.name, placeId: result.placeId);
      nearGymList.add(gymRowData);
    });
    MySharedPreferences.setNearGymList(nearGymList);
  }

  void showNearGymList() async{
    List<Widget> newGymList = List<Widget>();
    List<GymRowData> gymList = MySharedPreferences.getNearGymList();
    print(gymList);
    if(gymList == null || gymList.length == 0) return;
    gymList.forEach((gymRowData)=>newGymList.add(
        ListTile(
          onTap: (){print("listed");},
          leading: IconButton(
              icon: Icon(Icons.star_border, color: Colors.grey,),
              onPressed: () {}
          ),
          title: new Text(gymRowData.name),
          trailing: IconButton(
            icon: Icon(Icons.map),
            onPressed: () {_launchMaps(gymRowData.placeId);}
          ),
        )
      )
    );
    if(this.mounted){
      setState(() {
        params._nearGymList = newGymList;
      });
    }
  }
  void updatePosition() async{
    await this.setNearGymList();
    await showNearGymList();
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: Column(children: getNearGymWidgets()));
  }

  List<Widget> getNearGymWidgets() {
    List<Widget> widgets = new List<Widget>();
    widgets.add(Expanded(
      child: Container(
          child: RefreshIndicator(
              onRefresh: () async{
                await updatePosition();
              },
              child: new ListView(
                children: params._nearGymList,
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

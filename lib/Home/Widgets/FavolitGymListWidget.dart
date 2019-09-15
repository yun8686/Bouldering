import 'dart:convert';

import 'package:bouldering_sns/Home/Widgets/GymRowData.dart';
import 'package:bouldering_sns/Library/SharedPreferences.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:url_launcher/url_launcher.dart';

class FavoliteGymListWidget extends StatefulWidget {
  FavoliteGymListWidget({Key key}) : super(key: key);
  @override
  _FavoliteGymListState createState() => _FavoliteGymListState();
}

class _FavoliteGymListParam{
  List<Widget> _favoriteGymList = <Widget>[
    ListTile(
      leading: new CircleAvatar(
        backgroundImage: new NetworkImage("https://booth.pximg.net/c3d42cdb-5e97-43ff-9331-136453807f10/i/616814/d7def86b-1d95-4f2d-ad9c-c0c218e6a533_base_resized.jpg"),
      ),
      title: new Text("↓Pull to update"),
    ),
  ];
}

class _FavoliteGymListState extends State<FavoliteGymListWidget> {
  _FavoliteGymListParam params = null;
  final places = new GoogleMapsPlaces(apiKey: "AIzaSyAz4vCzntcPH_mbDvBK28AIv8CFieswdT4");

  @override
  void initState() {
    super.initState();
    params = _FavoliteGymListParam();
    // GPSの準備
    showFavoliteGymList();
  }

  void didChangeDependencies(){
    super.didChangeDependencies();
  }

  void showFavoliteGymList() async{
    List<Widget> newGymList = List<Widget>();
    List<GymRowData> gymList = await MySharedPreferences.getFavoriteGym();
    if(gymList == null || gymList.length == 0) return;
    gymList.forEach((gymRowData)=>newGymList.add(
        ListTile(
          onTap: (){print("listed");},
          leading: IconButton(
              icon: gymRowData.favolite == 0?
                Icon(Icons.star_border, color: Colors.grey,):
                Icon(Icons.star, color: Colors.yellow,),
              onPressed: () async{
                if(gymRowData.favolite == 0){
                  await MySharedPreferences.addFavoliteGymPlaceid(gymRowData.placeId);
                }else{
                  await MySharedPreferences.removeFavoliteGymPlaceid(gymRowData.placeId);
                }
                print(gymRowData.placeId);
                await showFavoliteGymList();
              }
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
        params._favoriteGymList = newGymList;
      });
    }
  }
  void updatePosition() async{
    await showFavoliteGymList();
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
                children: params._favoriteGymList,
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

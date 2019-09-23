import 'dart:convert';
import 'dart:math';

import 'package:bouldering_sns/GymDetail/GymGradeListWidget.dart';
import 'package:bouldering_sns/Home/Widgets/GymRowData.dart';
import 'package:bouldering_sns/Library/SharedPreferences.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_maps_webservice/places.dart' as prefix0;
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
      GymRowData gymRowData = GymRowData(name: result.name, placeId: result.placeId, favolite: 1, distance: distance(position, result.geometry.location));
      nearGymList.add(gymRowData);
    });
    MySharedPreferences.setNearGymList(nearGymList);
  }

  double distance(Position position, prefix0.Location googlePosition) {
    // 緯度経度をラジアンに変換
    double currentLa   = position.latitude * pi / 180.0;
    double currentLo   = position.longitude * pi / 180.0;
    double targetLa    = googlePosition.lat * pi / 180;
    double targetLo    = googlePosition.lng * pi / 180;
    // 赤道半径
    double equatorRadius = 6378137.0;

    // 算出
    double averageLat = (currentLa - targetLa) / 2.0;
    double averageLon = (currentLo - targetLo) / 2.0;
    double distance = equatorRadius * 2 * asin(sqrt(pow(sin(averageLat), 2) + cos(currentLa) * cos(targetLa) * pow(sin(averageLon), 2)));
    return distance / 1000.0;
}

  void showNearGymList() async{
    List<Widget> newGymList = List<Widget>();
    List<GymRowData> gymList = await MySharedPreferences.getNearGymList();
    if(gymList == null || gymList.length == 0) return;
    gymList.forEach((gymRowData)=>newGymList.add(GymHeaderCard(
      title: gymRowData.name,
      placeId: gymRowData.placeId,
      distance: gymRowData.distance,
      onTap: (){
        Navigator.push(context, new MaterialPageRoute<Null>(
          builder: (BuildContext context) => GymGradeListWidget(title: gymRowData.name, placeId: gymRowData.placeId,),
        ));
      },
      leadIconButton: IconButton(
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
            await showNearGymList();
          }
      ),
    )));
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
    List<Widget> users = List<Widget>();
    for (int i = 1; i <= 100; i++) {
      users.add(ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(
              "https://booth.pximg.net/c3d42cdb-5e97-43ff-9331-136453807f10/i/616814/d7def86b-1d95-4f2d-ad9c-c0c218e6a533_base_resized.jpg"),
        ),
        title: Text(name + i.toString()),
      ));
    }
    return users;
  }

}

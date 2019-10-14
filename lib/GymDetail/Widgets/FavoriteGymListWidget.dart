import 'package:bouldering_sns/Model/Gym/Gym.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FavoriteGymListWidget extends StatefulWidget {
  FavoriteGymListWidget({Key key}) : super(key: key);
  @override
  _FavoriteGymListState createState() => _FavoriteGymListState();
}

class _FavoriteGymListParam{
  List<Widget> _favoriteGymList = <Widget>[
    ListTile(
      leading: new CircleAvatar(
        backgroundImage: new NetworkImage("https://booth.pximg.net/c3d42cdb-5e97-43ff-9331-136453807f10/i/616814/d7def86b-1d95-4f2d-ad9c-c0c218e6a533_base_resized.jpg"),
      ),
      title: new Text("↓Pull to update"),
    ),
  ];
}

class _FavoriteGymListState extends State<FavoriteGymListWidget> {
  _FavoriteGymListParam params = null;

  @override
  void initState() {
    super.initState();
    params = _FavoriteGymListParam();
    // GPSの準備
    showFavoriteGymList();
  }

  void didChangeDependencies(){
    super.didChangeDependencies();
  }

  void showFavoriteGymList() async{
    List<Widget> newGymList = List<Widget>();
    List<Gym> gymList = await Gym.getFavoriteGymList();
    if(gymList == null || gymList.length == 0) return;
    gymList.forEach((gym)=>newGymList.add(
        ListTile(
          leading: IconButton(
              icon: gym.favorite == 0?
                Icon(Icons.star_border, color: Colors.grey,):
                Icon(Icons.star, color: Colors.yellow,),
              onPressed: () async{
                gym.setFavorite(!gym.favorite);
                await showFavoriteGymList();
              }
          ),
          title: new Text(gym.name),
          trailing: IconButton(
            icon: Icon(Icons.map),
            onPressed: () {_launchMaps(gym.place_id);}
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
    await showFavoriteGymList();
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: Column(children: getNearGymWidgets()));
  }

  List<Widget> getNearGymWidgets() {
    List<Widget> widgets = new List<Widget>();
    widgets.add(Expanded(
      child: Container(
        child: new ListView(
          children: params._favoriteGymList,
        )
      ),
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

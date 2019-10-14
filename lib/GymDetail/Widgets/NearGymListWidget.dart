import 'package:bouldering_sns/GymDetail/GymGradeListWidget.dart';
import 'package:bouldering_sns/Model/Gym/Gym.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NearGymListWidget extends StatefulWidget {
  NearGymListWidget({Key key}) : super(key: key);
  @override
  _NearGymListState createState() => _NearGymListState();
}

class _NearGymListState extends State<NearGymListWidget> {
  Future<List<Gym>> nearGymListFuture = Gym.getNearGymList(true);
  @override
  void initState() {
//    nearGymListFuture = Gym.getNearGymList(true);
    super.initState();
  }

  void didChangeDependencies() {
    nearGymListFuture = Gym.getNearGymList(true);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Gym>>(
      future: nearGymListFuture,
      builder: (BuildContext context, AsyncSnapshot<List<Gym>> snapshot) {
        ListView listView;
        switch (snapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.done:
            if(snapshot.hasData){
              listView = ListView(
                key: PageStorageKey(1),
                children: snapshot.data.map((gym) {
                  return listCard(gym);
                }).toList(),
              );
            }
            break;
          default:
            break;
        }

        if(listView == null){
          listView = ListView(
            children: <Widget>[
              ListTile(
                leading: const CircleAvatar(
                  backgroundImage: const NetworkImage(
                      "https://booth.pximg.net/c3d42cdb-5e97-43ff-9331-136453807f10/i/616814/d7def86b-1d95-4f2d-ad9c-c0c218e6a533_base_resized.jpg"),
                ),
                title: new Text("↓Pull to update"),
              )
            ],
          );
        }

        return RefreshIndicator(
          child: listView,
          onRefresh: (){
            this.nearGymListFuture = Gym.getNearGymList(false);
            return this.nearGymListFuture.then((data){
              if(this.mounted)setState(() {
                //this.nearGymListFuture = this.nearGymListFuture;
              });
            });
          },
        );
      },
    );
  }

  _GymHeaderCard listCard(Gym gym) {
    return _GymHeaderCard(
      title: gym.name,
      placeId: gym.place_id,
      distance: gym.distance,
      onTap: () {
        Navigator.push(
            context,
            new MaterialPageRoute<Null>(
              builder: (BuildContext context) => GymGradeListWidget(
                gym: gym,
              ),
            ));
      },
      leadIconButton: IconButton(
          icon: gym.favorite
              ? Icon(
                  Icons.star,
                  color: Colors.yellow,
                )
              : Icon(
                  Icons.star_border,
                  color: Colors.grey,
                ),
          onPressed: (){
            gym.setFavorite(!gym.favorite).then((newgym){
              if(this.mounted)setState((){
                gym.favorite = newgym.favorite;
              });
            });
          }),
    );
  }
}



class _GymHeaderCard extends StatelessWidget {
  String title, placeId;
  double distance;
  IconButton leadIconButton;
  void Function() onTap;
  _GymHeaderCard({this.title, this.placeId, this.leadIconButton, this.onTap, this.distance});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
        child: ListTile(
          leading: this.leadIconButton ??
              IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.grey,
                  ),
                  onPressed: () async {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  }),
          onTap: this.onTap ?? () {},
          title: Text(this.title.toString()),
          trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                distance!=null?Text("${(distance.toStringAsFixed(1))}km"):Text("0km"),
                IconButton(
                    icon: Icon(Icons.map),
                    onPressed: () {
                      _launchMaps(this.placeId);
                    }),
              ]
          ),
        ));
  }

  void _launchMaps(String placeId) async {
    String url =
        'https://www.google.com/maps/search/?api=1&query=Google&query_place_id=' +
            placeId;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch Maps';
    }
  }
}

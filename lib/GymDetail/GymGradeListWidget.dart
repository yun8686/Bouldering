import 'package:auto_size_text/auto_size_text.dart';
import 'package:bouldering_sns/GymDetail/ProblemDetailWidget.dart';
import 'package:bouldering_sns/GymDetail/ProblemListWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:url_launcher/url_launcher.dart';

class GymGradeListWidget extends StatelessWidget {
  String title, placeId;

  GymGradeListWidget({this.title, this.placeId}) {
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            _AppbarWidget(title: title, placeId: placeId),
            SliverList(
              delegate:new SliverChildListDelegate(<Widget>[
                _createGradeListTile(context, "10級"),
                _createGradeListTile(context, "9級"),
                _createGradeListTile(context, "8級"),
                _createGradeListTile(context, "7級"),
                _createGradeListTile(context, "6級"),
                _createGradeListTile(context, "5級"),
                _createGradeListTile(context, "4級"),
                _createGradeListTile(context, "3級"),
                _createGradeListTile(context, "2級"),
                _createGradeListTile(context, "1級"),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createGradeListTile(BuildContext context, String name){
    return _GradeListTile(
        name: name,
        onTap: () {
//          Navigator.push(context,CupertinoPageRoute<Null>(builder: (BuildContext context) => ProblemDetailWidget(name: name,title: this.title,placeId: this.placeId)));
          Navigator.push(context,CupertinoPageRoute<Null>(builder: (BuildContext context) => ProblemListWidget(title: name)));
        });
  }
}

class _AppbarWidget extends StatefulWidget{
  String title, placeId;
  _AppbarWidget({this.title, this.placeId});
  @override
  _AppbarWidgetState createState() => _AppbarWidgetState(title:title, placeId:placeId);
}
class _AppbarWidgetState extends State<_AppbarWidget>{
  String title, placeId, imageUrl;
  double imageHeight = 256.0;
  _AppbarWidgetState({this.title, this.placeId});
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final places = new GoogleMapsPlaces(apiKey: "AIzaSyAz4vCzntcPH_mbDvBK28AIv8CFieswdT4");
    places.getDetailsByPlaceId(placeId, language: "ja").then((val){
      Size mediasize = MediaQuery.of(context).size;
      setState((){
        this.imageHeight = (mediasize.width.toInt()/val.result.photos[0].width.toInt())*val.result.photos[0].height;
        this.imageUrl = places.buildPhotoUrl(photoReference: val.result.photos[0].photoReference, maxWidth: mediasize.width.toInt());
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SliverAppBar(
      pinned: true,
      expandedHeight: imageHeight,
      title: Text(this.title),
      flexibleSpace: new FlexibleSpaceBar(
        background: Image(fit: BoxFit.fitWidth, image: this.imageUrl!=null?NetworkImage(this.imageUrl):AssetImage('assets/backgroundimages/login.jpg')),
      ),
    );
  }

}

class _GradeListTile extends StatelessWidget{
  String name;
  void Function() onTap;
  _GradeListTile({this.name, this.onTap});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(child: ListTile(
      leading: Image(
        image: AssetImage('assets/backgroundimages/login.jpg'),
        fit: BoxFit.fill,
      ),
      title: Text(this.name,style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2.0),),
      trailing: Container(
          decoration: new BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(24),
          ),
        child: Text("99",style: new TextStyle(
          color: Colors.white,
          fontSize: 12,
          ),
          textAlign: TextAlign.center
        ),
          padding: EdgeInsets.all(8),
          constraints: BoxConstraints(
            minWidth: 24,
            minHeight: 24,
          ),
      ),
      onTap: this.onTap??(){
      },
    ),
    );
  }
}


class GymHeaderCard extends StatelessWidget {
  String title, placeId;
  double distance;
  IconButton leadIconButton;
  void Function() onTap;
  GymHeaderCard({this.title, this.placeId, this.leadIconButton, this.onTap, this.distance});
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

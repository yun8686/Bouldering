import 'package:bouldering_sns/GymDetail/ProblemListWidget.dart';
import 'package:bouldering_sns/Model/Gym/Grade.dart';
import 'package:bouldering_sns/Model/Gym/Gym.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GymGradeListWidget extends StatefulWidget {
  Gym gym;
  GymGradeListWidget({this.gym});

  @override
  State<GymGradeListWidget> createState() {
    return _GymGradeListState(gym: gym);
  }
}

class _GymGradeListState extends State<GymGradeListWidget> {
  Gym gym;
  List<Grade> gradeList = List<Grade>();

  _GymGradeListState({this.gym});
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Grade.getGymGradeList(gym.place_id).then((gradeList) {
      setState((){
        this.gradeList = gradeList;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            _AppbarWidget(gym: gym),
            _GradeListWidget(gradeList: this.gradeList),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: (){
            showModalBottomSheet(context: context, builder: (BuildContext context){
              return _CreateGradeModalWidget(
                gym: gym,
                doPop: (){
                  Grade.getGymGradeList(gym.place_id).then((gradeList) {
                    setState((){
                      this.gradeList = gradeList;
                    });
                  });
                },
              );
            });
          },
        ),
      ),
    );
  }
}

class _AppbarWidget extends StatefulWidget{
  Gym gym;
  _AppbarWidget({this.gym});
  @override
  _AppbarWidgetState createState() => _AppbarWidgetState(gym: this.gym);
}
class _AppbarWidgetState extends State<_AppbarWidget>{
  Gym gym;
  _AppbarWidgetState({this.gym});

  String title, placeId, imageUrl;
  double imageHeight = 256.0;
  @override
  void initState() {
    super.initState();
    title = gym.name;
    placeId = gym.place_id;
  }
  @override
  Widget build(BuildContext context) {
    Size mediasize = MediaQuery.of(context).size;
    gym.setImageInfo(mediasize).then((gym){
      if (mounted) setState(() {this.gym = gym;});
    });

    return SliverAppBar(
      pinned: true,
      expandedHeight: gym.imageHeight!=null?gym.imageHeight:imageHeight,
      title: Text(this.title),
      flexibleSpace: new FlexibleSpaceBar(
        background: Image(fit: BoxFit.fitWidth, image: gym.imageUrl!=null?NetworkImage(gym.imageUrl):AssetImage('assets/backgroundimages/login.jpg')),
      ),
    );
  }

}

class _GradeListWidget extends StatelessWidget{
  List<Grade> gradeList = List<Grade>();
  _GradeListWidget({this.gradeList});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate:SliverChildListDelegate(this.gradeList.map((grade){
        return _createGradeListTile(context, grade);
      }).toList())
    );
  }
  Widget _createGradeListTile(BuildContext context, Grade grade){
    return _GradeListTile(
        name: grade.name,
        onTap: () {
//          Navigator.push(context,CupertinoPageRoute<Null>(builder: (BuildContext context) => ProblemDetailWidget(name: name,title: this.title,placeId: this.placeId)));
          Navigator.push(context,CupertinoPageRoute<Null>(builder: (BuildContext context) => ProblemListWidget(grade: grade)));
        });
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

class _CreateGradeModalWidget extends StatefulWidget{
  Gym gym;
  Function doPop;
  _CreateGradeModalWidget({this.gym, this.doPop});
  @override
  State<_CreateGradeModalWidget> createState() {
    return _CreateGradeModalState(gym: gym, doPop: doPop);
  }
}

class _CreateGradeModalState extends State<_CreateGradeModalWidget>{
  Gym gym;
  Function doPop;

  String name;
  _CreateGradeModalState({this.gym, this.doPop});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
          children:[
            Text("新しい級を登録"),
            TextField(
              decoration: InputDecoration(
                hintText: '級を入力',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              onChanged: (text){
                this.name = text;
              },
            ),
            RaisedButton(
              child: Text("登録"),
              color: Colors.pink,
              textColor: Colors.white,
              onPressed: ()async{
                await Grade.create(gym, this.name);
                Navigator.pop(context);
                this.doPop();
              },
            ),
          ]
      ),
    );
  }

}

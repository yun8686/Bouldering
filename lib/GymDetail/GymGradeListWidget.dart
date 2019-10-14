import 'package:bouldering_sns/GymDetail/ProblemListWidget.dart';
import 'package:bouldering_sns/Model/Gym/Grade.dart';
import 'package:bouldering_sns/Model/Gym/Gym.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_picker/flutter_picker.dart';

class GymGradeListWidget extends StatefulWidget {
  Gym gym;
  GymGradeListWidget({this.gym});

  @override
  State<GymGradeListWidget> createState() {
    return _GymGradeListState(gym: gym);
  }
}

class _GymGradeListState extends State<GymGradeListWidget> {
  bool showAll = false;
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
            _GradeListWidget(gradeList: this.gradeList.where((g){return showAll||g.count!=0;}).toList()),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: (){
            setState(() {
              this.showAll = !this.showAll;
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
        grade: grade,
        onTap: () {
//          Navigator.push(context,CupertinoPageRoute<Null>(builder: (BuildContext context) => ProblemDetailWidget(name: name,title: this.title,placeId: this.placeId)));
          Navigator.push(context,CupertinoPageRoute<Null>(builder: (BuildContext context) => ProblemListWidget(grade: grade)));
        });
  }
}


class _GradeListTile extends StatelessWidget{
  Grade grade;
  void Function() onTap;
  _GradeListTile({this.grade, this.onTap});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(child: ListTile(
      leading: Image(
        image: AssetImage('assets/backgroundimages/login.jpg'),
        fit: BoxFit.fill,
      ),
      title: Text(grade.name,style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2.0),),
      trailing: Container(
          decoration: new BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(24),
          ),
        child: Text(grade.count.toString(),style: new TextStyle(
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


import 'package:bouldering_sns/Authentication/VerifyModal.dart';
import 'package:bouldering_sns/Chat/ChatWidget.dart';
import 'package:bouldering_sns/Library/SharedPreferences.dart';
import 'package:bouldering_sns/Model/User/User.dart';
import 'package:flutter/material.dart';

class FriendsWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new FriendsWidgetState();
}

class FriendsWidgetState extends State<FriendsWidget> {
  User loginUser;
  List<User> friendUserList = List<User>();
  List<User> nearUserList = List<User>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    MySharedPreferences.getAccountMode().then((mode){
      if(mode == MySharedPreferences.FullUser){
        setLoginUser().then((user) {
          setFriendUserList();
          setNearUserList();
        });
      }else{
        //VerifyModal.openModal(context);
      }
    });
  }

  Future<User> setLoginUser() {
    return User.getLoginUser().then((user) {
      this.loginUser = user;
      return user;
    });
  }

  void setFriendUserList() {
    User.getFriendUserList(true).then((userList) {
      setState(() {
        this.friendUserList = userList;
      });
    });
  }

  void setNearUserList() {
    User.nearUserList().then((userList) {
      setState(() {
        this.nearUserList = userList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
                title: Text("トーク"),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () {},
                  )
                ],
                bottom: TabBar(tabs: <Widget>[
                  Tab(text: "Friends"),
                  Tab(text: "near by"),
                ])),
            body: TabBarView(
              children: <Widget>[
                Center(child: Column(children: getFriendsWidgets())),
                Center(child: Column(children: getNearByWidgets())),
              ],
            )));
  }

  Widget getSearchArea() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        child: TextField(
          decoration: InputDecoration(
              hintText: "検索",
              filled: true,
              border: InputBorder.none,
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {},
              )),
        ));
  }

  List<Widget> getFriendsWidgets() {
    List<Widget> widgets = new List<Widget>();
    widgets.add(getSearchArea());
    widgets.add(Expanded(
      child: Container(
        child: ListView(
          children: nearUserList.map((user) {
            return UserTile(user);
          }).toList(),
        ),
      ),
    ));
    return widgets;
  }

  List<Widget> getNearByWidgets() {
    List<Widget> widgets = new List<Widget>();
    widgets.add(Expanded(
      child: Container(
          child: RefreshIndicator(
              onRefresh: () {},
              child: new ListView(
                children: nearUserList.map((user) {
                  return UserTile(user);
                }).toList(),
              ))),
    ));
    return widgets;
  }

  Widget UserTile(User user) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
            "https://booth.pximg.net/c3d42cdb-5e97-43ff-9331-136453807f10/i/616814/d7def86b-1d95-4f2d-ad9c-c0c218e6a533_base_resized.jpg"),
      ),
      title: Text(user.displayName),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute<Null>(
              builder: (BuildContext context) =>
                  ChatWidget(leftUser: user, rightUser: loginUser),
            ));
      },
    );
  }


}

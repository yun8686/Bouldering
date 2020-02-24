import 'package:bouldering_sns/CommonWidget/GymCard.dart';
import 'package:flutter/material.dart';

class GymDetailWidget extends StatefulWidget {
  @override
  State<GymDetailWidget> createState() => _GymDetailWidgetState();
}

class _GymDetailWidgetState extends State<GymDetailWidget>
    with SingleTickerProviderStateMixin {
  List<String> _tabs = <String>["新着",
       "人気",
  ];
  TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: _tabs.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Stack(
        children: <Widget>[
          Container(
            child:Align(
              alignment: Alignment.bottomLeft,
              child: FloatingActionButton.extended(
                heroTag: "exitBtn",
                label: Text("退店する"),
                onPressed: (){
              }),
            ),
            padding: EdgeInsets.only(left: 24),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              heroTag: "addBtn",
              onPressed: (){
              
            }),
          )
        ],
      ),
      appBar: AppBar(title: const Text('Books'), elevation: 0.0),
      body: DefaultTabController(
        length: _tabs.length,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              // AppBarとTabBarの間のコンテンツ
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Container(height: 200.0, child: _HeaderCard()),
                    _joinList(),
                  ],
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _StickyTabBarDelegate(
                  TabBar(
                    tabs: _tabs.map((String name) => Tab(text: name)).toList(),
                  ),
                ),
              ),
            ];
          },
          body: ListView.builder(
            itemCount: 3,
            itemBuilder: (BuildContext context, int index) {
              if(index == 0){
                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                    itemBuilder: (BuildContext context, int index){
                      if(index  == 3){
                        return Container(
                          width: 20.0,
                          height: 20.0,
                          child: new RawMaterialButton(
                            shape: new CircleBorder(),
                            elevation: 0.0,
                            child: new Icon(
                              Icons.add,
                              color: Colors.blue,
                            ),
                          onPressed: (){},
                          )
                        );
                      }else {
                        return _textLable("6級");
                      }
                    }
                  ),
                );
              }else{
                return GymCard.create(
                  context,
                  onTap: () {
                  }
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _HeaderCard(){
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          child: Image.network(
            'https://placeimg.com/640/480/any',
            fit: BoxFit.cover,
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            padding: EdgeInsets.only(left: 16),
            height: 60,
            child: Column(
              children: <Widget>[
                Align(alignment: Alignment.centerLeft,child: _joinStatus()),
                Align(alignment: Alignment.centerLeft,child: Text("ぼるこむ新宿店", style: TextStyle(color: Colors.white, fontSize: 24),),),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 入店中アイコンの表示
  Widget _joinStatus(){
    return Container(
      height: 20,
      width: 70,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green),
        color: Colors.green,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Center(
        child: Text("入店中", style: TextStyle(color: Colors.white,fontSize: 12),),
      ),
    );
  }
  
  // 入店中ユーザー一覧
  Widget _joinList(){
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: Text("入店している人"),
        ),
        Container(
          height: 80.0,
          child:ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 10,
          itemBuilder: (BuildContext context, int index){
            return Container(
              height: 60,
              width: 60,
              margin: EdgeInsets.all(8),
              child: CircleAvatar(
                radius: 40.0,
                backgroundImage: NetworkImage('https://placeimg.com/100/100/any'),
              ),
            );
          },
        )),
      ],
    );    
  }

  // 課題の一覧
  Widget _textLable(String text){
    return Container(
      height: 20,
      width: 70,
      margin: EdgeInsets.only(right:10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green),
        color: Colors.green,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Center(
        child: Text(text, style: TextStyle(color: Colors.white,fontSize: 12),),
      ),
    );
  }
}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  const _StickyTabBarDelegate(this.tabBar);

  final TabBar tabBar;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: Colors.blue, child: tabBar);
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar;
  }
}

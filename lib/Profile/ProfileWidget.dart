import 'package:bouldering_sns/CommonWidget/GymCard.dart';
import 'package:flutter/material.dart';

class ProfileWidget extends StatefulWidget {
  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();

}
class _ProfileWidgetState extends State<ProfileWidget>
    with SingleTickerProviderStateMixin {
  List<String> _tabs = <String>["通知","自分の投稿"];
  TabController _tabController;
  @override
  void initState() {
//    _tabController = TabController(length: _tabs.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('マイページ'),
      ),
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
                    _followInfoWidget(),
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
              return GymCard.create(
                context,
                onTap: () {
                }
              );
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
                Align(alignment: Alignment.centerLeft,child: Text("ぼるこむ新宿店", style: TextStyle(color: Colors.white, fontSize: 24),),),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // フォロー一覧
  Widget _followInfoWidget(){
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: Text("フォロー 100人"),
        ),
        Container(
          margin: EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: Text("フォロワー 100人"),
        ),
      ],
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




import 'package:bouldering_sns/GymDetail/Widgets/FavoriteGymListWidget.dart';
import 'package:bouldering_sns/GymDetail/Widgets/NearGymListWidget.dart';
import 'package:bouldering_sns/GymDetail/Widgets/UserPanelWidget.dart';
import 'package:flutter/material.dart';

class oldHomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DefaultTabController(
      length: 2,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 250.0,
              floating: false,
              flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                children: <Widget>[
                  ListView(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 10.0),
                        height: 240.0,
                        child: UserPanelWidget(),
                      ),
                    ],
                  )
                ],
              )),
            ),
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                TabBar(
                  tabs: [
                    Tab(text: "近いジム"),
                    Tab(text: "お気に入りジム"),
                  ],
                ),
              ),
              pinned: true,
            )
          ];
        },
        body: TabBarView(
          children: <Widget>[
            NearGymListWidget(key: PageStorageKey(1)),
            FavoriteGymListWidget(key: PageStorageKey(2)),
          ],
        ),
      ),
    ));
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

// ここから下が新しいデザイン

class HomeWidget extends StatelessWidget {
  Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.pin_drop),
        onPressed: () {},
      ),
      appBar: AppBar(
        title: Text("ホーム"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                width: size.width * 0.95,
                height: size.height * 0.5,
                child: Card(
                    child: Column(
                  children: <Widget>[
                    Text("お気に入り"),
                  ],
                )),
              ),
              SizedBox(
                  width: size.width * 0.95,
                  height: size.height * 0.5,
                  child: Row(children: <Widget>[
                    Expanded(
                      child: Card(
                        child: Column(
                          children: <Widget>[
                            Text("自分の投稿"),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        child: Column(
                          children: <Widget>[
                            Text("自分の投稿"),
                          ],
                        ),
                      ),
                    )
                  ]))
            ],
          ),
        ),
      ),
    );
  }
}

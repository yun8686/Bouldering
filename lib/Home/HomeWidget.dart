import 'package:bouldering_sns/Home/Widgets/NearGymListWidget.dart';
import 'package:flutter/material.dart';
import 'Widgets/UserPanelWidget.dart';

class HomeWidget extends StatelessWidget {
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
                        Tab(text: "遠いジム"),
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
                NearGymListWidget(key: PageStorageKey(2)),
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

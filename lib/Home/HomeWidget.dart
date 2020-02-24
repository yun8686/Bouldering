import 'package:bouldering_sns/CommonWidget/GymCard.dart';
import 'package:bouldering_sns/GymDetail/GymDetailWidget.dart';
import 'package:flutter/material.dart';

class HomeWidget extends StatelessWidget {
  Size size;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ホーム"),
      ),
      body: ListView.builder(
        itemCount: 3,
        itemBuilder: (BuildContext context, int index) {
          return GymCard.create(
            context,
            onTap: () {
              print("tapped");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => GymDetailWidget(),
                ),
              );
            }
          );
        },
      ),
    );
  }
}

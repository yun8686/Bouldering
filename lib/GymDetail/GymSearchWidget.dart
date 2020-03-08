import 'dart:io';

import 'package:flutter/material.dart';
import 'package:bouldering_sns/Model/Gym/Gym.dart';
import 'package:bouldering_sns/Model/Gym/GoogleMaps.dart';

class GymSearchWidget extends StatefulWidget {
  GymSearchWidget({Key key}) : super(key: key);
  @override
  _GymSearchState createState() => _GymSearchState();
}

class _GymSearchState extends State<GymSearchWidget> {
  // Future<List<Gym>> nearGymListFuture = Gym.getNearGymList(true);
  @override
  void initState() {
    super.initState();
  }

  void didChangeDependencies() {
    // nearGymListFuture = Gym.getNearGymList(true);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMaps();
  }
}
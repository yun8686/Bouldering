import 'dart:convert';

class GymRowData{
  String name,placeId;
  int favolite;
  double distance;
  GymRowData({this.name, this.placeId, this.favolite, this.distance});
  GymRowData.fromMap(Map map){
    this.name = map['name'];
    this.placeId = map['placeId'];
    this.favolite = map['favolite'];
    this.distance = map['distance'];
  }
  Map<String, dynamic> toMap() => {
    'name': name ,
    'placeId': placeId ,
    'favolite': favolite,
    'distance': distance,
  };
}
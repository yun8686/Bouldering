import 'dart:convert';

class GymRowData{
  String name,placeId;
  int favolite;
  GymRowData({String name, String placeId, int favolite}){
    this.name = name;
    this.placeId = placeId;
    this.favolite = favolite;
  }
  GymRowData.fromMap(Map map){
    this.name = map['name'];
    this.placeId = map['placeId'];
    this.favolite = map['favolite'];
  }
  Map<String, dynamic> toMap() => {
    'name': name ,
    'placeId': placeId ,
    'favolite': favolite,
  };
}
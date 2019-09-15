import 'dart:convert';

class GymRowData{
  String name,placeId;
  bool favolite;
  GymRowData({String name, String placeId, bool favolite}){
    this.name = name;
    this.placeId = placeId;
    this.favolite = favolite;
  }
  GymRowData.fromJSON(String jsonString){
    Map map = json.decode(jsonString);
    this.name = map['name'];
    this.placeId = map['placeId'];
    this.favolite = map['favolite'];
  }
  Map<String, dynamic> toJson() => {
    'name': name ,
    'placeId': placeId ,
    'favolite': favolite,
  };
}
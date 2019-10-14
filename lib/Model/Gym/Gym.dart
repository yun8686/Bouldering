import 'dart:ui';

import 'package:bouldering_sns/Library/SharedPreferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/directions.dart';
import 'dart:math';

import 'package:google_maps_webservice/places.dart';

class Gym{
  static String COLLECTION_NAME = "gyms";
  static CollectionReference collection = Firestore.instance.collection(COLLECTION_NAME);
  static final places = new GoogleMapsPlaces(apiKey: "AIzaSyAz4vCzntcPH_mbDvBK28AIv8CFieswdT4");

  String key;

  String name;
  String place_id;

  double lat;
  double lng;
  double distance;
  bool favorite;

  String imageUrl;
  double imageHeight;

  Gym({this.key, this.name, this.place_id, this.lat, this.lng, this.distance, this.favorite = false});
  Gym.fromDBMap(Map data){
      this.key = data['place_id'];
      this.name = data['name'];
      this.place_id = data['place_id'];
      this.distance = data['distance'];
      this.favorite = data['favorite']==1;
  }
  Future create(){
    return FirebaseAuth.instance.currentUser().then((user){
      return collection.document().setData({
        'name': name,
        'place_id': place_id,
        'lat': lat,
        'lng': lng,
      });
    });
  }


  static Future<Gym> getGymFromPlaceId(String place_id) async{
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return _findByPlaceId(place_id, position);
  }

  /**
   *  近いジム一覧を取得
   *    isCacheがtrueの場合は、DBにキャッシュした内容
   *             falseの場合は、APIから取得してキャッシュに保存する
   */
  static Future<List<Gym>> getNearGymList(bool isCache) async {
    if(!isCache){
      GeolocationStatus geolocationStatus  = await Geolocator().checkGeolocationPermissionStatus();
      Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      PlacesSearchResponse response = await places.searchByText("ロッククライミングジム", language: "ja", location: Location(position.latitude, position.longitude));
      await Future.wait(response.results.map((data){
        return _findByPlaceId(data.placeId, position);
      })).then((List<Gym> gymList){
        MySharedPreferences.setNearGymList(gymList);
        return gymList;
      });
    }
    return await MySharedPreferences.getNearGymList();
  }

  /**
   * お気に入りしたジムの一覧を取得
   *
   */
  static Future<List<Gym>> getFavoriteGymList() async {
    return await MySharedPreferences.getFavoriteGymList();
  }

  static Future<Gym> _findByPlaceId(String place_id, Position position)async{
    return await collection.document(place_id).get().then((onValue){
      if(onValue.data != null){
        return new Gym(
          key: place_id,
          name: onValue.data['name'],
          place_id: onValue.data['place_id'],
          lat: onValue.data['geometry']['location']['lat'],
          lng: onValue.data['geometry']['location']['lng'],
          distance: _distance(position, Location.fromJson(onValue.data['geometry']['location'])),
        );
      }else{
        return new Gym(
          key: place_id,
          place_id: place_id,
          name: "のーん" + Random().nextInt(100).toString()
        );
      }
    });
  }

  Future<Gym> setImageInfo(Size mediasize) async{
    final places = new GoogleMapsPlaces(apiKey: "AIzaSyAz4vCzntcPH_mbDvBK28AIv8CFieswdT4");
    return places.getDetailsByPlaceId(this.place_id, language: "ja").then((val){
      if(!val.hasNoResults){
        this.imageHeight = (mediasize.width.toInt()/val.result.photos[0].width.toInt())*val.result.photos[0].height;
        this.imageUrl = places.buildPhotoUrl(photoReference: val.result.photos[0].photoReference, maxWidth: mediasize.width.toInt());
      }
      return this;
    });
  }

  Future<Gym> setFavorite(bool new_favorite) async{
    if(new_favorite){
      return await MySharedPreferences.addFavoriteGymPlaceid(this.place_id).then((g){
        this.favorite = true;
        return this;
      });
    }else{
      return await MySharedPreferences.removeFavoriteGymPlaceid(this.place_id).then((g){
        this.favorite = false;
        return this;
      });
    }
  }



  static double _distance(Position position, Location googlePosition) {
    // 緯度経度をラジアンに変換
    double currentLa   = position.latitude * pi / 180.0;
    double currentLo   = position.longitude * pi / 180.0;
    double targetLa    = googlePosition.lat * pi / 180;
    double targetLo    = googlePosition.lng * pi / 180;
    // 赤道半径
    double equatorRadius = 6378137.0;

    // 算出
    double averageLat = (currentLa - targetLa) / 2.0;
    double averageLon = (currentLo - targetLo) / 2.0;
    double distance = equatorRadius * 2 * asin(sqrt(pow(sin(averageLat), 2) + cos(currentLa) * cos(targetLa) * pow(sin(averageLon), 2)));
    return distance / 1000.0;
  }


//  static Stream<QuerySnapshot> stream() => Firestore.instance.collection(COLLECTION_NAME).snapshots().listen(onData).;

}


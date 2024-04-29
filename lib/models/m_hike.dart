import 'package:cloud_firestore/cloud_firestore.dart';
class Todo{
  String name;
  String description;
  String locationOfHike;
  int levelOfHike;
  int lengthOfHike;
  Timestamp date;
  bool parkingAvailable;
  String createdAccount;

  Todo({
    required this.name,
    required this.description,
    required this.locationOfHike,
    required this.levelOfHike,
    required this.lengthOfHike,
    required this.date,
    required this.parkingAvailable,
    required this.createdAccount,
  });
  Todo.formJson(Map<String,Object>?json):this(
    name: json?['name']! as String,
    description: json?['description']! as String,
    locationOfHike: json?['locationOfHike']! as String,
    levelOfHike: json?['levelOfHike']! as int,
    lengthOfHike: json?['lengthOfHike']! as int,
    date: json?['date']! as Timestamp,
    parkingAvailable: json?['parkingAvailable']! as bool,
    createdAccount: json?['createdAccount']! as String,
  );
  Todo copyWith(
      {
        String? name,
        String? locationOfHike,
        int?lengthOfHike,
        int?levelOfHike,
        String? description,
        Timestamp? date,
        bool? parkingAvailable,
        String? createdAccount,
      }){
    return Todo(
        name: name??this.name,
        description: description??this.description,
        locationOfHike: locationOfHike??this.locationOfHike,
        levelOfHike: levelOfHike??this.levelOfHike,
        lengthOfHike: lengthOfHike??this.levelOfHike,
        date: date??this.date,
        parkingAvailable: parkingAvailable??this.parkingAvailable,
        createdAccount: createdAccount??this.createdAccount,
       );
  }
  Map<String,Object?>toJson(){
    return{
      'name':name,
      'description':description,
      'locationOfHike':locationOfHike,
      'levelOfHike':levelOfHike,
      'lengthOfHike':lengthOfHike,
      'date':date,
      'parkingAvailable':parkingAvailable,
      'createdAccount':createdAccount,
    };
  }
}
class UserData{
  String displayName;
  String email;
  String password;

  UserData({
    required this.displayName,
    required this.email,
    required this.password,
  });
  UserData.formJson(Map<String,Object>?json):this(
    displayName: json?['displayName']! as String,
    email: json?['email']! as String,
    password: json?['password']! as String,
  );
  UserData copyWith(
      {
        String? displayName,
        String? email,
        String?password,
      }){
    return UserData(
      displayName: displayName??this.displayName,
      email: email??this.email,
      password: password??this.password,
    );
  }
  Map<String,Object?>toJson(){
    return{
      'displayName':displayName,
      'email':email,
      'password':password,
    };
  }
}

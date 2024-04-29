import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/m_hike.dart';

const String USER_COLLECTION_REF="user_mhike_database";


class DatabaseUserService{
  final _fierstore=FirebaseFirestore.instance;
  late final CollectionReference _userdatasRef;

  DatabaseUserService(){
    _userdatasRef=_fierstore.collection(USER_COLLECTION_REF).withConverter<UserData>(
        fromFirestore: (snapshots,_)=>UserData.formJson(
          snapshots.data()?.cast<String, Object>(),
        ) ,
        toFirestore: (userdata,_)=>userdata.toJson());
  }
Stream<QuerySnapshot> getUserDatas(){
    return _userdatasRef.snapshots();
  }
  Future<void> updateUserData(String userdataId, UserData userdata) async {
    try {
      await _userdatasRef.doc(userdataId).update(userdata.toJson());
      print('UserData updated successfully!'); // Informative success message
    } catch (error) {
      print('Error updating userdata: $error'); // Log the error for debugging
    }
  }
  Future<void> addUserData(UserData userdata) async {
    try {
      await _userdatasRef.add(userdata);
      print('UserData added successfully!'); // Informative success message
    } catch (error) {
      print('Error adding userdata: $error'); // Log the error for debugging
    }
  }

  Future<void> deleteUserData(String userdataId) async {
    try {
      await _userdatasRef.doc(userdataId).delete();
      print('UserData deleted successfully!'); // Informative success message
    } catch (error) {
      print('Error deleting userdata: $error'); // Log the error for debugging
    }
  }
}
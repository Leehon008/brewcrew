import 'package:brewcrew/models/brew.dart';
import 'package:brewcrew/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;

  DatabaseService({this.uid});

  // collection reference
  final CollectionReference brewCollection =
      FirebaseFirestore.instance.collection('brews');

  // update user data objects
  Future updateUserData(String sugars, String name, int strength) async {
    return await brewCollection.doc(uid).set({
      'sugars': sugars,
      'name': name,
      'strength': strength,
    });
  }

  // brew list from snapshot
  List<Brew> _brewListFromSnapshot(QuerySnapshot? querySnapshot) {
    return querySnapshot!.docs.map((doc) {
      return Brew(
        name: doc['name'] ?? '',
        sugars: doc['sugars'] ?? 0,
        strength: doc['strength'] ?? '0',
      );
    }).toList();
  }

  //get brews stream
  Stream<List<Brew>> get brews {
    return brewCollection.snapshots().map(_brewListFromSnapshot);
  }

  //user data from snapshot
  UserDataModel _userDataFromSnapshot(DocumentSnapshot documentSnapshot) {
    return UserDataModel(
      uid: uid!,
      name: documentSnapshot['name'],
      sugars: documentSnapshot['sugars'],
      strength: documentSnapshot['strength'],
    );
  }

  //get user doc stream
  Stream<UserDataModel> get userData {
    return brewCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }
}

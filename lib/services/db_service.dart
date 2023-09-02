import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:happy_paws_v2/models/user_model.dart';
import 'package:happy_paws_v2/providers/auth_provider.dart';

import '../models/pet_model.dart';

class DBService {
  static DBService instance = DBService();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final String _userCollection = "Users";
  final String _petsCollection = "Pets";

  Future<void> createdUserInDB(String uid, String name, String email,
      String phone, String imageURL) async {
    try {
      await _db.collection(_userCollection).doc(uid).set({
        "name": name,
        "email": email,
        "phone": phone,
        "image": imageURL,
        "address": "",
        "aboutMe": "",
      });
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  Stream<UserData> getUserData(String userID) {
    return _db
        .collection(_userCollection)
        .doc(userID)
        .snapshots()
        .map((snapshot) => UserData.fromFirestore(snapshot));
  }

  Future<void> updateUserInDB(UserData user) async {
    try {
      await _db.collection(_userCollection).doc(user.id).update({
        "name": user.name,
        "phone": user.phone,
        "image": user.image,
        "address": user.address,
        "aboutMe": user.aboutMe,
      });
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  Stream<List<PetData>> get petsDataStream {
    return _db
        .collection(_userCollection)
        .doc(AuthProvider.instance.user!.uid)
        .collection(_petsCollection)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return PetData.fromFirestore(doc);
      }).toList();
    });
  }

  Stream<PetData> petDataStrem(String petID) {
    return _db
        .collection(_userCollection)
        .doc(AuthProvider.instance.user!.uid)
        .collection(_petsCollection)
        .doc(petID)
        .snapshots()
        .map((querySnapshot) {
      return PetData.fromFirestore(querySnapshot);
    });
  }

  Future<void> deletePet(String petID) async {
    await _db
        .collection(_userCollection)
        .doc(AuthProvider.instance.user!.uid)
        .collection(_petsCollection)
        .doc(petID)
        .delete();
  }

  Future<void> createPetInDB(PetData pet) async {
    try {
      await _db
          .collection(_userCollection)
          .doc(AuthProvider.instance.user!.uid)
          .collection(_petsCollection)
          .add({
        'images': pet.images,
        'aboutMe': pet.aboutMe,
        'birthDate': pet.birthDate,
        'age': pet.age,
        'characteristics': pet.characteristics,
        'profileImage': pet.profileImage,
        'name': pet.name,
        'nickname': pet.nickname,
        'race': pet.race,
        'sex': pet.sex,
        'size': pet.size,
        'type': pet.type,
        'weight': pet.weight
      });
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }
}

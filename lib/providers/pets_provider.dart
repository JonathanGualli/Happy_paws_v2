import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:happy_paws_v2/models/pet_model.dart';
import 'package:happy_paws_v2/services/db_service.dart';

class PetsProvider extends ChangeNotifier {
  static PetsProvider instance = PetsProvider();

  Stream<List<PetData>> get petsStream => DBService.instance.petsDataStream;

  Stream<PetData> petStream(String petID) {
    return DBService.instance.petDataStrem(petID);
  }

  Future<void> deletePet(String petID) async {
    await DBService.instance.deletePet(petID);
    notifyListeners();
  }

  Future<void> addPetInDB(String name, String type, String race,
      String nickname, String aboutMe, String image) async {
    await DBService.instance.createPetInDB(
      PetData(
        id: "",
        images: List<dynamic>.empty(),
        aboutMe: aboutMe,
        birthDate: Timestamp.fromDate(DateTime(1950, 1, 1)),
        age: "",
        characteristics: List<dynamic>.empty(),
        profileImage: image,
        name: name,
        nickname: nickname,
        race: race,
        sex: "",
        size: "",
        type: type,
        weight: "",
      ),
    );
  }
}

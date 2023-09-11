import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:happy_paws_v2/models/pet_model.dart';
import 'package:happy_paws_v2/providers/auth_provider.dart';
import 'package:happy_paws_v2/services/db_service.dart';

class PetsProvider extends ChangeNotifier {
  String? petSelected;
  List<String> petNames = [];

  static PetsProvider instance = PetsProvider();
  Stream<List<PetData>> get petsStream => DBService.instance.petsDataStream;

  PetsProvider() {
    DBService.instance
        .getSelectedPet()
        .then((data) => petSelected = data)
        .then((_) => notifyListeners());
    //notifyListeners();
  }

  void listenToPetsData(Stream<List<PetData>> petsDataStream) {
    petsDataStream.listen((petsData) {
      // Procesa los datos y obtén los nombres de las mascotas
      final newPetNames = petsData.map((petData) => petData.name).toList();

      // Actualiza la lista de nombres en el provider
      petNames = newPetNames;

      notifyListeners(); // Notificar a los oyentes (como widgets) sobre el cambio en los datos
    });
  }

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
          qrImage: "",
          isUpdate: false,
          isSelected: false),
    );
  }

  Future<void> updatePetInDB(PetData pet) {
    return DBService.instance.updatePetInDB(
      PetData(
          id: pet.id,
          images: pet.images,
          aboutMe: pet.aboutMe,
          birthDate: pet.birthDate,
          age: pet.age,
          characteristics: pet.characteristics,
          profileImage: pet.profileImage,
          name: pet.name,
          nickname: pet.nickname,
          race: pet.race,
          sex: pet.sex,
          size: pet.size,
          type: pet.type,
          weight: pet.weight,
          qrImage: pet.qrImage,
          isUpdate: pet.isUpdate,
          isSelected: pet.isSelected),
    );
  }

  Future<void> selectPet(String petID) {
    if (petSelected != null) {
      DBService.instance.selectPetInDB(petSelected!, false);
    }

    petSelected = petID;
    notifyListeners();
    return DBService.instance.selectPetInDB(petSelected!, true);
  }

  Future<String> numberOfPets() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(AuthProvider.instance.user!.uid)
        .collection("Pets")
        .get();
    String dato;
    if (snapshot.docs.isEmpty) {
      dato = "😞 Parece que no tienes mascotas 😢";
    } else {
      dato = "Dueño de ${snapshot.docs.length} mascota/s";
    }
    return dato;
  }
}

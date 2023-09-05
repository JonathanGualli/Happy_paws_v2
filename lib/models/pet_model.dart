import 'package:cloud_firestore/cloud_firestore.dart';

class PetData {
  late final String id;
  late final List<dynamic>? images;
  late final String aboutMe;
  late final Timestamp birthDate;
  late final String age;
  late final List<dynamic> characteristics;
  late final String profileImage;
  late final String name;
  late final String nickname;
  late final String race;
  late final String sex;
  late final String size;
  late final String type;
  late final String weight;
  late final String qrImage;
  late final bool isUpdate;
  late final bool isSelected;

  PetData(
      {required this.id,
      required this.images,
      required this.aboutMe,
      required this.birthDate,
      required this.age,
      required this.characteristics,
      required this.profileImage,
      required this.name,
      required this.nickname,
      required this.race,
      required this.sex,
      required this.size,
      required this.type,
      required this.weight,
      required this.qrImage,
      required this.isUpdate,
      required this.isSelected});

  factory PetData.fromFirestore(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return PetData(
      id: snapshot.id,
      images: data["images"],
      aboutMe: data["aboutMe"],
      birthDate: data["birthDate"],
      age: data["age"],
      characteristics: data["characteristics"],
      profileImage: data["profileImage"],
      name: data["name"],
      nickname: data["nickname"],
      race: data["race"],
      sex: data["sex"],
      size: data["size"],
      type: data["type"],
      weight: data["weight"],
      qrImage: data["qrImage"],
      isUpdate: data["isUpdate"],
      isSelected: data["isSelected"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'images': images,
      'aboutMe': aboutMe,
      "birthDate": birthDate,
      "age": age,
      "characteristics": characteristics,
      "profileImage": profileImage,
      "name": name,
      "nickname": nickname,
      "race": race,
      "sex": sex,
      "size": size,
      "type": type,
      "weight": weight,
      "qrImage": qrImage,
      "isUpdate": isUpdate,
      "isSelected": isSelected
    };
  }

  String generateNonEmptyAttributesString() {
    final Map<String, dynamic> petAttributes = toMap();
    final List<String> nonEmptyAttributes = [];

    petAttributes.forEach((key, value) {
      if (value != null && value.toString().toString() != "") {
        nonEmptyAttributes.add('$key: $value');
      }
    });

    return nonEmptyAttributes.join(', ');
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  late final String id;
  late final String name;
  late final String email;
  late final String phone;
  late final String address;
  late final String image;
  late final String aboutMe;

  UserData(
      {required this.id,
      required this.name,
      required this.email,
      required this.phone,
      required this.address,
      required this.image,
      required this.aboutMe});

  factory UserData.fromFirestore(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return UserData(
      id: snapshot.id,
      name: data["name"],
      email: data["email"],
      phone: data["phone"],
      address: data["address"],
      image: data["image"],
      aboutMe: data["aboutMe"],
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      "image": image,
      "aboutMe": aboutMe
    };
  } 
}

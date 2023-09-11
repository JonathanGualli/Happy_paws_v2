import 'package:cloud_firestore/cloud_firestore.dart';

class ReminderData {
  late final String id;
  late final String petName;
  late final String description;
  late final Timestamp dateTime;
  late final bool isEnabled;
  ReminderData({
    required this.id,
    required this.petName,
    required this.description,
    required this.dateTime,
    required this.isEnabled,
  });

  factory ReminderData.fromFirestore(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return ReminderData(
        id: snapshot.id,
        petName: data["petName"],
        description: data["description"],
        dateTime: data["dateTime"],
        isEnabled: data["isEnabled"]);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'petName': petName,
      'description': description,
      'dateTime': dateTime,
      'isEnabled': isEnabled,
    };
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class Organisation {
  final String id;
  final String name;

  Organisation({this.id, this.name});

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  factory Organisation.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return Organisation(id: doc.documentID, name: data['name'] ?? '');
  }
}

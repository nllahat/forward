import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {
  final String id;
  final String name;
  final String description;
  final GeoPoint location;
  final bool isActive;
  final Timestamp startDate;
  final Timestamp endDate;
  final List<String> coordinators;

  Activity(
      {this.id,
      this.name,
      this.description,
      this.location,
      this.isActive,
      this.startDate,
      this.endDate,
      this.coordinators});

  factory Activity.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    List<DocumentReference> coordinatoresDocRef = new List<DocumentReference>.from(data['coordinators']);

    return Activity(
        id: doc.documentID,
        name: data['name'] ?? '',
        description: data['description'] ?? '',
        location: data['location'],
        isActive: data['isActive'] ?? false,
        startDate: data['startDate'],
        endDate: data['endDate'],
        coordinators: coordinatoresDocRef.map((elem) => elem.documentID).toList());
  }
}

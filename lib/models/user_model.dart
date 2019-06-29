import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String firebaseUserId;
  final String firstName;
  final String lastName;
  final String phoneNumber;

  User(
      {this.id,
      this.firebaseUserId,
      this.firstName,
      this.lastName,
      this.phoneNumber,
      });

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return User(
        id: doc.documentID,
        firebaseUserId: doc['firebaseUserId'] ?? '',
        firstName: data['firstName'] ?? '',
        lastName: data['lastName'] ?? '',
        phoneNumber: data['phoneNumber'] ?? '');
  }
}

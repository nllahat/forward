import 'package:cloud_firestore/cloud_firestore.dart';

enum Gender { Female, Male }

class User {
  final String id;
  final String firebaseUserId;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String email;
  final DateTime birthDate;
  final Gender gender;

  User(
      {this.id,
      this.firebaseUserId,
      this.firstName,
      this.lastName,
      this.phoneNumber,
      this.email,
      this.birthDate,
      this.gender});

  factory User.fromJson(Map<String, dynamic> json) => new User(
        id: json["id"],
        firebaseUserId: json["firebaseUserId"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        phoneNumber: json["phoneNumber"],
        email: json["email"],
        birthDate: json["birthDate"],
        gender: json["gender"],
      );

  Map<String, dynamic> toJson() => {
        "firebaseUserId": firebaseUserId,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
      };

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return User(
        id: doc.documentID,
        firebaseUserId: doc['firebaseUserId'] ?? '',
        firstName: data['firstName'] ?? '',
        lastName: data['lastName'] ?? '',
        phoneNumber: data['phoneNumber'] ?? '',
        birthDate: data['birthDate'].toDate());
  }
}

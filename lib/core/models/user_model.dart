import 'package:cloud_firestore/cloud_firestore.dart';

enum Gender { Female, Male }

class User {
  final String id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String email;
  final DateTime birthDate;
  final Gender gender;

  User(
      {this.id,
      this.firstName,
      this.lastName,
      this.phoneNumber,
      this.email,
      this.birthDate,
      this.gender});

  factory User.fromJson(Map<String, dynamic> json) => new User(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        phoneNumber: json["phoneNumber"],
        email: json["email"],
        birthDate: json["birthDate"],
        gender: json["gender"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "phoneNumber": phoneNumber,
        "email": email,
        "birthDate": birthDate,
        "gender": gender == Gender.Female ? 'female' : 'male',
      };

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return User(
        id: doc.documentID,
        firstName: data['firstName'] ?? '',
        lastName: data['lastName'] ?? '',
        phoneNumber: data['phoneNumber'] ?? '',
        email: data['email'] ?? '',
        gender: data['gender'] == 'female' ? Gender.Female : Gender.Male,
        birthDate: data['birthDate'].toDate());
  }
}

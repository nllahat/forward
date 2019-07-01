import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:forward/models/user_model.dart';

class UserRepository {
  final Firestore _db = Firestore.instance;

  Stream<List<User>> streamUsers() {
    var ref = _db.collection('users');

    return ref.snapshots().map((list) =>
        list.documents.map((doc) => User.fromFirestore(doc)).toList());
  }

  /// Get a stream of a single document
  Stream<User> streamUser(String id) {
    return _db
        .collection('users')
        .document(id)
        .snapshots()
        .map((snap) => User.fromFirestore(snap));
  }

  /// Get a single document
  Future<User> getUser(String id) async {
    DocumentSnapshot doc = await _db.collection('users').document(id).get();

    return User.fromFirestore(doc);
  }

  /// Get a single document
  Future<User> getUserByPhoneNumber(String phoneNumber) async {
    QuerySnapshot doc = await _db
        .collection('users')
        .where('phoneNumber', isEqualTo: phoneNumber)
        .getDocuments();

    if (doc.documents != null && doc.documents.length > 0) {
      return User.fromFirestore(doc.documents[0]);
    } else {
      return null;
    }
  }

  Future<void> addUser() {
    Map<String, dynamic> dataMap = new Map<String, dynamic>();

    dataMap['user'] = _db.document('users/' + userId);
    dataMap['event'] = _db.document('events/' + eventId);
    dataMap['timestamp'] = Timestamp.now();
    dataMap['isCanceled'] = false;
    dataMap['extraGuests'] = extraGuests;

    return _db.collection('registrations').add(dataMap).then((onValue) {
      return;
    }).catchError((e) {
      print(e);
      return;
    });
  }
}

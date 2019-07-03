import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:forward/models/user_model.dart';

class UserRepository {
  static final Firestore _db = Firestore.instance;

  Stream<List<User>> streamUsers() {
    var ref = _db.collection('users');

    return ref.snapshots().map((list) =>
        list.documents.map((doc) => User.fromFirestore(doc)).toList());
  }

  /// Get a stream of a single document
  static Stream<User> streamUser(String id) {
    return _db
        .collection('users')
        .document(id)
        .snapshots()
        .map((snap) => User.fromFirestore(snap));
  }

  /// Get a single document
  static Future<User> getUser(String id) async {
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

  static Future<bool> checkUserExist(String userId) async {
    bool exists = false;
    try {
      await Firestore.instance.document("users/$userId").get().then((doc) {
        if (doc.exists)
          exists = true;
        else
          exists = false;
      });
      return exists;
    } catch (e) {
      return false;
    }
  }

  static void addUser(User user) {
    checkUserExist(user.id).then((value) {
      if (!value) {
        Firestore.instance
            .document("users/${user.id}")
            .setData(user.toJson());
      } else {
        print("user ${user.firstName} ${user.email} exists");
      }
    });
  }
}

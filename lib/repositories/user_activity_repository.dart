import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:forward/models/user_activity_model.dart';

class UserActivityRepository {
  static final Firestore _db = Firestore.instance;

  static Stream<List<UserActivity>> streamUsersActivities() {
    var ref = _db.collection('users_activities');

    return ref.snapshots().map((list) =>
        list.documents.map((doc) => UserActivity.fromFirestore(doc)).toList());
  }

  static Stream<Map<String, UserActivity>> streamUserUserActivitesMap(
      String userId) {
    Stream<Map<String, UserActivity>> usersActivitiesStream;
    Map<String, UserActivity> map = new Map();
    DocumentReference userDocRef = _db.collection('users').document(userId);

    usersActivitiesStream = _db
        .collection('users_activities')
        .where('user', isEqualTo: userDocRef)
        .orderBy('timestamp')
        .snapshots()
        .map((list) {
      list.documents.forEach((doc) {
        var userActivity = UserActivity.fromFirestore(doc);

        map[userActivity.activityId] = userActivity;
      });

      return map;
    });

    return usersActivitiesStream;
  }

  static Stream<List<UserActivity>> streamUsersActivitiesByUserId(
      String userId) {
    var userDocRef = _db.collection('users').document(userId);

    return _db
        .collection('users_activities')
        .where('user', isEqualTo: userDocRef)
        .orderBy('timestamp')
        .snapshots()
        .map((list) => list.documents
            .map((doc) => UserActivity.fromFirestore(doc))
            .toList());
  }

  static Stream<UserActivity> streamUserActivity(String id) {
    return _db
        .collection('users_activities')
        .document(id)
        .snapshots()
        .map((snap) => UserActivity.fromFirestore(snap));
  }

  static Future<Stream<UserActivity>> addUserActivity(
      UserActivity userActivity) {
    Map<String, dynamic> jsonMap = userActivity.toJson();
    jsonMap["user"] = _db.document("users/${jsonMap["user"]}");
    jsonMap["activity"] = _db.document("activities/${jsonMap["activity"]}");

    return _db
        .collection('users_activities')
        .add(jsonMap)
        .then((DocumentReference value) {
      return value.snapshots().map((snap) => UserActivity.fromFirestore(snap));
    }).catchError((onError) {
      throw onError;
    });
  }

  static Future<void> deleteUserActivity(UserActivity userActivity) {
    return _db.collection("users_activities").document(userActivity.id).delete();
  }
}

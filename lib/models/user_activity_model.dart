import 'package:cloud_firestore/cloud_firestore.dart';

class UserActivity {
  String id;
  String userId;
  String activityId;
  bool isCancelled;
  DateTime timestamp;

  UserActivity({
    id,
    userId,
    activityId,
    isCancelled: false,
    timestamp,
  })  : this.userId = userId,
        this.activityId = activityId,
        this.isCancelled = isCancelled ?? false,
        this.timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        "user": userId,
        "activity": activityId,
        "isCancelled": isCancelled,
        "timestamp": timestamp,
      };

  factory UserActivity.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    DocumentReference userRef = data['user'];
    DocumentReference activityRef = data['activity'];
    Timestamp timestamp = data['timestamp'];

    return UserActivity(
        id: doc.documentID,
        userId: userRef.documentID,
        activityId: activityRef.documentID,
        isCancelled: data['isCancelled'],
        timestamp: timestamp.toDate());
  }
}

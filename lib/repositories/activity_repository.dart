import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:forward/models/activity_model.dart';

class ActivityRepository {
  static final Firestore _db = Firestore.instance;

  static Stream<List<Activity>> streamActivities() {
    var ref = _db.collection('activities');

    return ref.snapshots().map((list) =>
        list.documents.map((doc) => Activity.fromFirestore(doc)).toList());
  }

  static Stream<Activity> streamActivity(String id) {
    return _db
        .collection('activities')
        .document(id)
        .snapshots()
        .map((snap) => Activity.fromFirestore(snap));
  }

  static Future<Activity> getActivity(String id) async {
    DocumentSnapshot doc =
        await _db.collection('activities').document(id).get();

    if (doc.exists == false) {
      return null;
    }

    return Activity.fromFirestore(doc);
  }

  static Future<void> addActivity(Activity activity) async {
    Firestore.instance
        .document("activities/${activity.id}")
        .setData(activity.toJson());
  }
}

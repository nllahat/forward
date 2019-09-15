import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:forward/core/models/organisation_model.dart';

class OrganisationRepository {
  static final Firestore _db = Firestore.instance;

  static Stream<List<Organisation>> streamOrganisations() {
    var ref = _db.collection('organisations');

    return ref.snapshots().map((list) =>
        list.documents.map((doc) => Organisation.fromFirestore(doc)).toList());
  }

  static Stream<Organisation> streamOrganisation(String id) {
    return _db
        .collection('organisations')
        .document(id)
        .snapshots()
        .map((snap) => Organisation.fromFirestore(snap));
  }

  static Future<void> addOrganisation(Organisation organisation) async {
    Firestore.instance
        .document("organisations/${organisation.id}")
        .setData(organisation.toJson());
  }
}

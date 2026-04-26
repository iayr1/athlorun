import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreBackend {
  FirestoreBackend(this._firestore);

  final FirebaseFirestore _firestore;

  Future<Map<String, dynamic>> getDocument({
    required String collection,
    required String docId,
    Map<String, dynamic> fallback = const {},
  }) async {
    final snapshot = await _firestore.collection(collection).doc(docId).get();
    return snapshot.data() ?? fallback;
  }

  Future<List<Map<String, dynamic>>> getCollection({
    required String collection,
    String? field,
    dynamic isEqualTo,
  }) async {
    Query<Map<String, dynamic>> query = _firestore.collection(collection);
    if (field != null) {
      query = query.where(field, isEqualTo: isEqualTo);
    }
    final snapshot = await query.get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<Map<String, dynamic>> upsertDocument({
    required String collection,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    await _firestore.collection(collection).doc(docId).set(data, SetOptions(merge: true));
    return data;
  }

  Future<void> deleteDocument({
    required String collection,
    required String docId,
  }) async {
    await _firestore.collection(collection).doc(docId).delete();
  }
}

class FirestoreBackend {
  FirestoreBackend();

  static final Map<String, Map<String, Map<String, dynamic>>> _db = {};

  Future<Map<String, dynamic>> getDocument({
    required String collection,
    required String docId,
    Map<String, dynamic> fallback = const {},
  }) async {
    return Map<String, dynamic>.from(
      _db[collection]?[docId] ?? fallback,
    );
  }

  Future<List<Map<String, dynamic>>> getCollection({
    required String collection,
    String? field,
    dynamic isEqualTo,
  }) async {
    final docs = _db[collection]?.values.toList() ?? [];
    if (field == null) {
      return docs.map((e) => Map<String, dynamic>.from(e)).toList();
    }

    return docs
        .where((doc) => doc[field] == isEqualTo)
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  Future<Map<String, dynamic>> upsertDocument({
    required String collection,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    final map = _db.putIfAbsent(collection, () => {});
    map[docId] = {
      ...?map[docId],
      ...data,
    };
    return Map<String, dynamic>.from(map[docId]!);
  }

  Future<void> deleteDocument({
    required String collection,
    required String docId,
  }) async {
    _db[collection]?.remove(docId);
  }
}

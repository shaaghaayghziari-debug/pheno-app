/// Storage abstraction for PHENO's offline-first data layer.
///
/// The MVP keeps this interface independent from SQLite/Drift/Isar so the
/// production database can be selected without changing domain code.
abstract interface class LocalStore {
  Future<void> put(String collection, String id, Map<String, Object?> data);
  Future<Map<String, Object?>?> get(String collection, String id);
  Future<List<Map<String, Object?>>> list(String collection);
  Future<void> delete(String collection, String id);
  Future<void> clear(String collection);
}

/// Deterministic in-memory implementation for development and tests.
/// Replace with an encrypted, persistent adapter before production.
class MemoryLocalStore implements LocalStore {
  final Map<String, Map<String, Map<String, Object?>>> _collections = {};

  Map<String, Map<String, Object?>> _collection(String name) =>
      _collections.putIfAbsent(name, () => {});

  @override
  Future<void> put(String collection, String id, Map<String, Object?> data) async {
    _collection(collection)[id] = Map<String, Object?>.from(data);
  }

  @override
  Future<Map<String, Object?>?> get(String collection, String id) async {
    final value = _collection(collection)[id];
    return value == null ? null : Map<String, Object?>.from(value);
  }

  @override
  Future<List<Map<String, Object?>>> list(String collection) async =>
      _collection(collection).values
          .map(Map<String, Object?>.from)
          .toList(growable: false);

  @override
  Future<void> delete(String collection, String id) async {
    _collection(collection).remove(id);
  }

  @override
  Future<void> clear(String collection) async {
    _collection(collection).clear();
  }
}

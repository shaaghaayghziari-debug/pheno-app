/// Storage abstraction for secrets such as refresh/session tokens.
///
/// Production implementations must use the platform secure storage facilities
/// (Keychain on iOS and Keystore-backed storage on Android). The MVP keeps this
/// interface provider-neutral and does not pretend that in-memory storage is
/// secure at rest.
abstract interface class SecureStorage {
  Future<void> write(String key, String value);
  Future<String?> read(String key);
  Future<void> delete(String key);
  Future<void> clear();
}

class InMemorySecureStorage implements SecureStorage {
  final Map<String, String> _values = {};

  @override
  Future<void> write(String key, String value) async => _values[key] = value;

  @override
  Future<String?> read(String key) async => _values[key];

  @override
  Future<void> delete(String key) async => _values.remove(key);

  @override
  Future<void> clear() async => _values.clear();
}

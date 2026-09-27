import '../models/security_models.dart';

/// Provider-neutral security contracts used by the PHENO MVP.
/// Production adapters must provide real platform secure storage, authentication,
/// consent persistence, audit persistence, and authenticated sync.
abstract interface class AccountService {
  Future<PhenoUser?> currentUser();
  Future<void> signOut();
}

abstract interface class ConsentRepository {
  Future<List<ConsentRecord>> getConsents();
  Future<void> saveConsent(ConsentRecord consent);
}

abstract interface class AuditRepository {
  Future<void> append(AuditEvent event);
}

abstract interface class AccountSyncRepository {
  Future<void> pushPending();
  Future<void> pullRemoteChanges();
}

class LocalOnlyAccountService implements AccountService {
  @override
  Future<PhenoUser?> currentUser() async => null;

  @override
  Future<void> signOut() async {}
}

class InMemoryConsentRepository implements ConsentRepository {
  final List<ConsentRecord> _items = [];

  @override
  Future<List<ConsentRecord>> getConsents() async => List.unmodifiable(_items);

  @override
  Future<void> saveConsent(ConsentRecord consent) async {
    _items.removeWhere((item) => item.type == consent.type);
    _items.add(consent);
  }
}

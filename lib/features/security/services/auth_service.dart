import '../models/security_models.dart';
import '../../../core/security/secure_storage.dart';

abstract interface class AuthService {
  Future<PhenoUser?> currentUser();
  Future<PhenoUser> signIn({required String identifier, required String secret});
  Future<void> signOut();
}

/// Provider-neutral placeholder. It deliberately does not authenticate against
/// a real server yet. Replace this adapter when the production identity provider
/// is selected; the app-facing contract stays unchanged.
class PendingAuthService implements AuthService {
  final SecureStorage storage;
  PhenoUser? _user;

  PendingAuthService({required this.storage});

  @override
  Future<PhenoUser?> currentUser() async => _user;

  @override
  Future<PhenoUser> signIn({required String identifier, required String secret}) async {
    if (identifier.trim().isEmpty || secret.isEmpty) {
      throw ArgumentError('Identifier and secret are required.');
    }
    final now = DateTime.now();
    _user = PhenoUser(id: 'pending-user', email: identifier.trim(), createdAt: now);
    await storage.write('pheno.session.pending', _user!.id);
    return _user!;
  }

  @override
  Future<void> signOut() async {
    _user = null;
    await storage.delete('pheno.session.pending');
  }
}

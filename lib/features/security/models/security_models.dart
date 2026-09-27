enum AuthStatus { signedOut, signingIn, signedIn, error }

enum ConsentType { privacyPolicy, clinicalSafety, cloudSync, analytics }

enum SyncStatus { idle, queued, syncing, synced, conflict, failed }

enum AuditEventType { signIn, signOut, consentChanged, syncStarted, syncCompleted, syncConflict }

class PhenoUser {
  final String id;
  final String? email;
  final String? displayName;
  final DateTime createdAt;

  const PhenoUser({
    required this.id,
    this.email,
    this.displayName,
    required this.createdAt,
  });
}

class ConsentRecord {
  final ConsentType type;
  final bool granted;
  final DateTime updatedAt;
  final String version;

  const ConsentRecord({
    required this.type,
    required this.granted,
    required this.updatedAt,
    required this.version,
  });
}

class SyncItem {
  final String id;
  final String entityType;
  final String entityId;
  final String operation;
  final DateTime createdAt;
  final int retryCount;
  final SyncStatus status;

  const SyncItem({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.operation,
    required this.createdAt,
    this.retryCount = 0,
    this.status = SyncStatus.queued,
  });
}

class AuditEvent {
  final String id;
  final AuditEventType type;
  final DateTime createdAt;
  final String? metadata;

  const AuditEvent({
    required this.id,
    required this.type,
    required this.createdAt,
    this.metadata,
  });
}

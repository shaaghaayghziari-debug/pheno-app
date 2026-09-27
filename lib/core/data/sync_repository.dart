import '../security/sync_queue.dart';

/// Boundary between local persistence and a future authenticated API.
/// No medication dose or treatment decision is changed by sync.
abstract interface class SyncRepository {
  Future<SyncResult> pushPending(List<SyncOperation> operations);
  Future<List<SyncOperation>> pullChanges({String? cursor});
}

class PendingSyncRepository implements SyncRepository {
  @override
  Future<SyncResult> pushPending(List<SyncOperation> operations) async =>
      SyncResult.pending(operations);

  @override
  Future<List<SyncOperation>> pullChanges({String? cursor}) async => const [];
}

class SyncResult {
  const SyncResult._({required this.status, this.remaining = const []});

  final SyncStatus status;
  final List<SyncOperation> remaining;

  factory SyncResult.pending(List<SyncOperation> operations) =>
      SyncResult._(status: SyncStatus.waitingForBackend, remaining: operations);
}

enum SyncStatus { synced, waitingForBackend, conflict, failed }

import '../models/security_models.dart';

abstract interface class SyncQueueService {
  Future<void> enqueue(SyncItem item);
  Future<List<SyncItem>> pendingItems();
  Future<void> markSynced(String id);
  Future<void> markConflict(String id);
}

class InMemorySyncQueueService implements SyncQueueService {
  final Map<String, SyncItem> _items = {};

  @override
  Future<void> enqueue(SyncItem item) async => _items[item.id] = item;

  @override
  Future<List<SyncItem>> pendingItems() async => _items.values
      .where((item) => item.status == SyncStatus.queued || item.status == SyncStatus.failed)
      .toList(growable: false);

  @override
  Future<void> markSynced(String id) async {
    final item = _items[id];
    if (item == null) return;
    _items[id] = SyncItem(
      id: item.id,
      entityType: item.entityType,
      entityId: item.entityId,
      operation: item.operation,
      createdAt: item.createdAt,
      retryCount: item.retryCount,
      status: SyncStatus.synced,
    );
  }

  @override
  Future<void> markConflict(String id) async {
    final item = _items[id];
    if (item == null) return;
    _items[id] = SyncItem(
      id: item.id,
      entityType: item.entityType,
      entityId: item.entityId,
      operation: item.operation,
      createdAt: item.createdAt,
      retryCount: item.retryCount,
      status: SyncStatus.conflict,
    );
  }
}

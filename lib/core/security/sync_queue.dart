enum SyncOperationType { create, update, delete }

enum SyncOperationStatus { pending, inFlight, completed, failed, conflict }

class SyncOperation {
  const SyncOperation({
    required this.id,
    required this.entity,
    required this.entityId,
    required this.type,
    required this.payload,
    this.status = SyncOperationStatus.pending,
    this.attempts = 0,
  });

  final String id;
  final String entity;
  final String entityId;
  final SyncOperationType type;
  final Map<String, Object?> payload;
  final SyncOperationStatus status;
  final int attempts;

  SyncOperation copyWith({SyncOperationStatus? status, int? attempts}) => SyncOperation(
        id: id,
        entity: entity,
        entityId: entityId,
        type: type,
        payload: payload,
        status: status ?? this.status,
        attempts: attempts ?? this.attempts,
      );
}

class SyncQueue {
  final List<SyncOperation> _items = [];

  List<SyncOperation> get pending => List.unmodifiable(
        _items.where((item) => item.status == SyncOperationStatus.pending),
      );

  void enqueue(SyncOperation operation) => _items.add(operation);

  void markCompleted(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index == -1) return;
    _items[index] = _items[index].copyWith(status: SyncOperationStatus.completed);
  }
}

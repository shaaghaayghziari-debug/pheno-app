import '../../../core/data/local_store.dart';
import '../models/dose_event.dart';
import '../models/dose_event_record.dart';

class DoseEventRepository {
  DoseEventRepository(this._store);
  static const _collection = 'dose_events';
  final LocalStore _store;

  Future<void> save(DoseEventRecord event) => _store.put(_collection, event.id, event.toMap());

  Future<DoseEventRecord?> findById(String id) async {
    final row = await _store.get(_collection, id);
    return row == null ? null : DoseEventRecord.fromMap(row);
  }

  Future<List<DoseEventRecord>> getRange(DateTime from, DateTime to) async {
    final rows = await _store.list(_collection);
    return rows.map(DoseEventRecord.fromMap).where((e) => !e.scheduledAt.isBefore(from) && !e.scheduledAt.isAfter(to)).toList()
      ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
  }

  Future<void> updateStatus(String id, DoseEventStatus status) async {
    final event = await findById(id);
    if (event == null) return;
    await save(event.copyWith(status: status));
  }

  Future<List<DoseEventRecord>> getForMedication(String medicationId) async {
    final rows = await _store.list(_collection);
    return rows.map(DoseEventRecord.fromMap).where((e) => e.medicationId == medicationId).toList(growable: false);
  }
}

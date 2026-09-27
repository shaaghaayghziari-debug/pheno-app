import '../../../core/data/local_store.dart';
import '../models/medication_record.dart';

class MedicationRepository {
  MedicationRepository(this._store);

  static const _collection = 'medications';
  final LocalStore _store;

  Future<void> save(MedicationRecord medication) =>
      _store.put(_collection, medication.id, medication.toMap());

  Future<MedicationRecord?> findById(String id) async {
    final data = await _store.get(_collection, id);
    return data == null ? null : MedicationRecord.fromMap(data);
  }

  Future<List<MedicationRecord>> getAll() async {
    final rows = await _store.list(_collection);
    return rows.map(MedicationRecord.fromMap).toList(growable: false);
  }

  Future<void> delete(String id) => _store.delete(_collection, id);

  Future<bool> consumeOne(String id) async {
    final item = await findById(id);
    if (item == null) return false;
    final remaining = item.remainingQuantity ?? item.quantity ?? 0;
    if (remaining <= 0) return false;
    await save(item.copyWith(remainingQuantity: remaining - 1));
    return true;
  }
}

import '../models/security_models.dart';

abstract interface class ConsentService {
  Future<List<ConsentRecord>> records();
  Future<void> setConsent(ConsentRecord record);
}

class InMemoryConsentService implements ConsentService {
  final Map<ConsentType, ConsentRecord> _records = {};

  @override
  Future<List<ConsentRecord>> records() async => _records.values.toList(growable: false);

  @override
  Future<void> setConsent(ConsentRecord record) async => _records[record.type] = record;
}

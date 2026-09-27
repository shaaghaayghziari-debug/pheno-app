import '../models/prescription_parse.dart';

abstract class PrescriptionOcrService {
  Future<PrescriptionParseResult> analyze(String imagePath);
}

/// Adapter for a real OCR provider.
/// It deliberately returns an unconfirmed state until a production OCR service is connected.
class PendingPrescriptionOcrService implements PrescriptionOcrService {
  @override
  Future<PrescriptionParseResult> analyze(String imagePath) async {
    return const PrescriptionParseResult(
      rawText: '',
      needsHumanReview: true,
      fields: <ParsedPrescriptionField>[],
    );
  }
}

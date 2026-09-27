enum ParseConfidence { high, medium, low, unknown }

enum ParseField { medicationName, dose, form, quantity, frequency, duration, mealInstruction }

class ParsedPrescriptionField {
  final ParseField field;
  final String value;
  final ParseConfidence confidence;
  final bool requiresReview;

  const ParsedPrescriptionField({
    required this.field,
    required this.value,
    required this.confidence,
    required this.requiresReview,
  });
}

class PrescriptionParseResult {
  final List<ParsedPrescriptionField> fields;
  final String rawText;
  final bool needsHumanReview;

  const PrescriptionParseResult({
    required this.fields,
    required this.rawText,
    required this.needsHumanReview,
  });
}

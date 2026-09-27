enum ScanFieldConfidence { high, medium, low, unknown }

enum ScanStatus { idle, analyzing, review, confirmed }

class PrescriptionField<T> {
  const PrescriptionField({required this.value, required this.confidence, this.rawText});
  final T value;
  final ScanFieldConfidence confidence;
  final String? rawText;

  bool get needsConfirmation => confidence == ScanFieldConfidence.low || confidence == ScanFieldConfidence.unknown;
}

class PrescriptionMedicationDraft {
  const PrescriptionMedicationDraft({
    required this.name,
    required this.dose,
    required this.form,
    required this.frequency,
    required this.duration,
    required this.instruction,
    required this.confidence,
  });

  final PrescriptionField<String> name;
  final PrescriptionField<String> dose;
  final PrescriptionField<String> form;
  final PrescriptionField<String> frequency;
  final PrescriptionField<String> duration;
  final PrescriptionField<String> instruction;
  final ScanFieldConfidence confidence;

  bool get needsConfirmation =>
      name.needsConfirmation || dose.needsConfirmation || form.needsConfirmation ||
      frequency.needsConfirmation || duration.needsConfirmation || instruction.needsConfirmation;
}

class PrescriptionScan {
  const PrescriptionScan({required this.status, this.medications = const [], this.noteFa, this.noteEn});

  final ScanStatus status;
  final List<PrescriptionMedicationDraft> medications;
  final String? noteFa;
  final String? noteEn;

  bool get hasUncertainFields => medications.any((m) => m.needsConfirmation);
}

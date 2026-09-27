enum ClinicalSourceType { label, guideline, reference }
enum EvidenceLevel { high, moderate, limited, unavailable }
enum InteractionType { drugDrug, drugFood, drugSupplement, drugCondition }

class ClinicalSource {
  final String title;
  final String reference;
  final ClinicalSourceType type;
  const ClinicalSource({required this.title, required this.reference, required this.type});
}

class InteractionRecord {
  final String subject;
  final String fa;
  final String en;
  final InteractionType type;
  final EvidenceLevel evidence;
  final ClinicalSource source;

  const InteractionRecord({
    required this.subject,
    required this.fa,
    required this.en,
    required this.type,
    required this.evidence,
    required this.source,
  });
}

class ClinicalMedicationProfile {
  final String ingredient;
  final String nameFa;
  final String nameEn;
  final EvidenceLevel evidence;
  final List<InteractionRecord> interactions;
  final String? foodFa;
  final String? foodEn;
  final ClinicalSource primarySource;

  const ClinicalMedicationProfile({
    required this.ingredient,
    required this.nameFa,
    required this.nameEn,
    required this.evidence,
    required this.interactions,
    required this.foodFa,
    required this.foodEn,
    required this.primarySource,
  });
}

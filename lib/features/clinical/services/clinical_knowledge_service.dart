import '../models/clinical_knowledge.dart';

/// Read-only clinical knowledge adapter.
/// Production data must come from licensed/authoritative drug-information sources.
/// This demo contains no treatment-changing rules.
class ClinicalKnowledgeService {
  ClinicalMedicationProfile? lookup(String ingredient) {
    final key = ingredient.trim().toLowerCase();
    if (key == 'amoxicillin') {
      return const ClinicalMedicationProfile(
        ingredient: 'amoxicillin',
        nameFa: 'آموکسی‌سیلین',
        nameEn: 'Amoxicillin',
        evidence: EvidenceLevel.high,
        foodFa: 'برچسب/منبع دارویی معتبر باید مبنای دستور غذا و زمان مصرف باشد؛ این نمونه تصمیم درمانی ایجاد نمی‌کند.',
        foodEn: 'Use authoritative product information for food and timing instructions; this demo does not create treatment decisions.',
        primarySource: ClinicalSource(
          title: 'Authoritative drug labeling',
          reference: 'FDA / DailyMed-style labeling adapter',
          type: ClinicalSourceType.label,
        ),
        interactions: <InteractionRecord>[],
      );
    }
    return null;
  }
}

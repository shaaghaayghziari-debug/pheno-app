enum FoodEffect { neutral, takeWithFood, emptyStomach, mayImproveAbsorption, mayReduceAbsorption }

enum EvidenceLevel { high, moderate, limited, unavailable }

enum SafetySeverity { info, caution, urgent }

class SafetyItem {
  final String titleFa;
  final String titleEn;
  final String detailFa;
  final String detailEn;
  final SafetySeverity severity;
  final EvidenceLevel evidenceLevel;

  const SafetyItem({
    required this.titleFa,
    required this.titleEn,
    required this.detailFa,
    required this.detailEn,
    this.severity = SafetySeverity.info,
    this.evidenceLevel = EvidenceLevel.unavailable,
  });

  String title(bool fa) => fa ? titleFa : titleEn;
  String detail(bool fa) => fa ? detailFa : detailEn;
}

class FoodGuidance {
  final FoodEffect effect;
  final String? helpfulFa;
  final String? helpfulEn;
  final String? reduceFa;
  final String? reduceEn;
  final String? timingFa;
  final String? timingEn;
  final EvidenceLevel evidenceLevel;

  const FoodGuidance({
    required this.effect,
    this.helpfulFa,
    this.helpfulEn,
    this.reduceFa,
    this.reduceEn,
    this.timingFa,
    this.timingEn,
    this.evidenceLevel = EvidenceLevel.unavailable,
  });
}

class Medication {
  final String nameFa;
  final String nameEn;
  final String activeIngredientFa;
  final String activeIngredientEn;
  final String dosage;
  final String formFa;
  final String formEn;
  final int quantity;
  final int remainingQuantity;
  final String frequencyFa;
  final String frequencyEn;
  final String durationFa;
  final String durationEn;
  final String nextDose;
  final String instructionFa;
  final String instructionEn;
  final FoodGuidance foodGuidance;
  final List<String> interactionsFa;
  final List<String> interactionsEn;
  final List<String> warningsFa;
  final List<String> warningsEn;
  final List<SafetyItem> safetyItems;

  const Medication({
    required this.nameFa,
    required this.nameEn,
    required this.activeIngredientFa,
    required this.activeIngredientEn,
    required this.dosage,
    required this.formFa,
    required this.formEn,
    required this.quantity,
    required this.remainingQuantity,
    required this.frequencyFa,
    required this.frequencyEn,
    required this.durationFa,
    required this.durationEn,
    required this.nextDose,
    required this.instructionFa,
    required this.instructionEn,
    required this.foodGuidance,
    this.interactionsFa = const [],
    this.interactionsEn = const [],
    this.warningsFa = const [],
    this.warningsEn = const [],
    this.safetyItems = const [],
  });

  String name(bool fa) => fa ? nameFa : nameEn;
  String activeIngredient(bool fa) => fa ? activeIngredientFa : activeIngredientEn;
  String form(bool fa) => fa ? formFa : formEn;
  String frequency(bool fa) => fa ? frequencyFa : frequencyEn;
  String duration(bool fa) => fa ? durationFa : durationEn;
  String instruction(bool fa) => fa ? instructionFa : instructionEn;
  List<String> interactions(bool fa) => fa ? interactionsFa : interactionsEn;
  List<String> warnings(bool fa) => fa ? warningsFa : warningsEn;
  List<SafetyItem> safety(bool fa) => safetyItems;
}

const demoMedication = Medication(
  nameFa: 'آموکسی‌سیلین',
  nameEn: 'Amoxicillin',
  activeIngredientFa: 'آموکسی‌سیلین',
  activeIngredientEn: 'Amoxicillin',
  dosage: '500 mg',
  formFa: 'کپسول',
  formEn: 'Capsule',
  quantity: 21,
  remainingQuantity: 14,
  frequencyFa: 'هر ۸ ساعت',
  frequencyEn: 'Every 8 hours',
  durationFa: '۷ روز',
  durationEn: '7 days',
  nextDose: '21:00',
  instructionFa: 'با یک لیوان آب مصرف شود.',
  instructionEn: 'Take with a glass of water.',
  foodGuidance: FoodGuidance(
    effect: FoodEffect.neutral,
    timingFa: 'با یا بدون غذا، طبق دستور نسخه مصرف شود.',
    timingEn: 'May be taken with or without food, as prescribed.',
    evidenceLevel: EvidenceLevel.high,
  ),
  interactionsFa: ['در صورت مصرف داروها یا مکمل‌های دیگر، بررسی تداخل توصیه می‌شود.'],
  interactionsEn: ['Check for interactions if you take other medicines or supplements.'],
  warningsFa: ['در صورت حساسیت شناخته‌شده به پنی‌سیلین‌ها، با پزشک یا داروساز مشورت کنید.'],
  warningsEn: ['If you have a known penicillin allergy, contact your doctor or pharmacist.'],
  safetyItems: [
    SafetyItem(
      titleFa: 'بررسی تداخل',
      titleEn: 'Interaction review',
      detailFa: 'برای داروها و مکمل‌های هم‌زمان، بررسی تداخل باید بر اساس منبع بالینی معتبر انجام شود.',
      detailEn: 'Concurrent medicines and supplements should be checked against a trusted clinical interaction source.',
      severity: SafetySeverity.caution,
      evidenceLevel: EvidenceLevel.high,
    ),
    SafetyItem(
      titleFa: 'حساسیت دارویی',
      titleEn: 'Drug allergy',
      detailFa: 'اگر سابقه حساسیت دارویی دارید، قبل از مصرف با پزشک یا داروساز بررسی کنید.',
      detailEn: 'If you have a history of drug allergy, check with a doctor or pharmacist before taking it.',
      severity: SafetySeverity.caution,
      evidenceLevel: EvidenceLevel.high,
    ),
  ],
);

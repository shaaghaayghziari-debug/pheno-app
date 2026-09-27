enum RefillStatus { healthy, low, critical, finished, unknown }

class CabinetItem {
  final String medicationNameFa;
  final String medicationNameEn;
  final String dosage;
  final int remainingQuantity;
  final double dosesPerDay;
  final DateTime? startDate;
  final DateTime? expectedEndDate;
  final int refillAlertDays;

  const CabinetItem({
    required this.medicationNameFa,
    required this.medicationNameEn,
    required this.dosage,
    required this.remainingQuantity,
    required this.dosesPerDay,
    this.startDate,
    this.expectedEndDate,
    this.refillAlertDays = 3,
  });

  String name(bool fa) => fa ? medicationNameFa : medicationNameEn;

  DateTime? estimatedRunOutDate({DateTime? from}) {
    if (remainingQuantity <= 0 || dosesPerDay <= 0) return null;
    final base = from ?? DateTime.now();
    final days = (remainingQuantity / dosesPerDay).ceil();
    return DateTime(base.year, base.month, base.day).add(Duration(days: days));
  }

  RefillStatus status({DateTime? from}) {
    if (remainingQuantity <= 0) return RefillStatus.finished;
    if (dosesPerDay <= 0) return RefillStatus.unknown;
    final daysLeft = remainingQuantity / dosesPerDay;
    if (daysLeft <= 1) return RefillStatus.critical;
    if (daysLeft <= refillAlertDays) return RefillStatus.low;
    return RefillStatus.healthy;
  }
}

const demoCabinetItems = <CabinetItem>[
  CabinetItem(
    medicationNameFa: 'آموکسی‌سیلین',
    medicationNameEn: 'Amoxicillin',
    dosage: '500 mg',
    remainingQuantity: 14,
    dosesPerDay: 3,
    refillAlertDays: 3,
  ),
  CabinetItem(
    medicationNameFa: 'ایبوپروفن',
    medicationNameEn: 'Ibuprofen',
    dosage: '400 mg',
    remainingQuantity: 10,
    dosesPerDay: 2,
    refillAlertDays: 3,
  ),
  CabinetItem(
    medicationNameFa: 'لوزارتان',
    medicationNameEn: 'Losartan',
    dosage: '50 mg',
    remainingQuantity: 26,
    dosesPerDay: 1,
    refillAlertDays: 7,
  ),
];

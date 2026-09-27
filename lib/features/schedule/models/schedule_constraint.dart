enum ScheduleConstraintType {
  exactTime,
  everyHours,
  beforeFood,
  withFood,
  afterFood,
  emptyStomach,
  minimumSpacing,
}

class ScheduleConstraint {
  final ScheduleConstraintType type;
  final String? relatedMedication;
  final int? hours;
  final int? minutes;
  final String? noteFa;
  final String? noteEn;

  const ScheduleConstraint({
    required this.type,
    this.relatedMedication,
    this.hours,
    this.minutes,
    this.noteFa,
    this.noteEn,
  });
}

class MedicationSchedule {
  final String medicationName;
  final String dosage;
  final DateTime startDate;
  final DateTime endDate;
  final List<ScheduleConstraint> constraints;
  final bool asNeeded;

  const MedicationSchedule({
    required this.medicationName,
    required this.dosage,
    required this.startDate,
    required this.endDate,
    this.constraints = const [],
    this.asNeeded = false,
  });
}

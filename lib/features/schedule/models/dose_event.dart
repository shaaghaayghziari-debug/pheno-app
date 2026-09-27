enum DoseEventStatus { upcoming, taken, missed }

class DoseEvent {
  final String medicationName;
  final String dosage;
  final DateTime scheduledAt;
  final String? instructionFa;
  final String? instructionEn;
  final DoseEventStatus status;

  const DoseEvent({
    required this.medicationName,
    required this.dosage,
    required this.scheduledAt,
    this.instructionFa,
    this.instructionEn,
    this.status = DoseEventStatus.upcoming,
  });
}

class ScheduleConflict {
  final String medicationA;
  final String medicationB;
  final String reasonFa;
  final String reasonEn;

  const ScheduleConflict({
    required this.medicationA,
    required this.medicationB,
    required this.reasonFa,
    required this.reasonEn,
  });
}

class SchedulePlan {
  final List<DoseEvent> events;
  final List<ScheduleConflict> conflicts;

  const SchedulePlan({
    required this.events,
    this.conflicts = const [],
  });

  bool get hasConflicts => conflicts.isNotEmpty;
}

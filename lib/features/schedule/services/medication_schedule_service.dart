import '../../medications/models/medication_record.dart';
import '../models/dose_event.dart';
import '../models/dose_event_record.dart';
import '../models/schedule_constraint.dart';
import '../repositories/dose_event_repository.dart';
import 'schedule_engine.dart';

class MedicationScheduleService {
  MedicationScheduleService(this._events);
  final DoseEventRepository _events;
  final ScheduleEngine _engine = const ScheduleEngine();

  Future<SchedulePlan> buildAndPersist({
    required List<MedicationRecord> medications,
    required DateTime from,
    required DateTime to,
  }) async {
    final schedules = <MedicationSchedule>[];
    final sourceByName = <String, MedicationRecord>{};
    for (final medication in medications) {
      sourceByName[medication.name] = medication;
      if (medication.asNeeded || medication.scheduleTimesMinutes.isEmpty) continue;
      schedules.add(MedicationSchedule(
        medicationName: medication.name,
        dosage: medication.dose ?? '',
        startDate: medication.startDate ?? from,
        endDate: medication.endDate ?? to,
        asNeeded: medication.asNeeded,
        constraints: medication.scheduleTimesMinutes.map((minutes) => ScheduleConstraint(
          type: ScheduleConstraintType.exactTime,
          minutes: minutes,
        )).toList(growable: false),
      ));
    }

    final plan = _engine.build(schedules: schedules, from: from, to: to);
    for (final event in plan.events) {
      final medication = sourceByName[event.medicationName];
      if (medication == null) continue;
      final id = '${medication.id}_${event.scheduledAt.toIso8601String()}';
      if (await _events.findById(id) != null) continue;
      await _events.save(DoseEventRecord(
        id: id,
        medicationId: medication.id,
        medicationName: medication.name,
        dosage: medication.dose ?? '',
        scheduledAt: event.scheduledAt,
        instructionFa: event.instructionFa,
        instructionEn: event.instructionEn,
      ));
    }
    return plan;
  }
}

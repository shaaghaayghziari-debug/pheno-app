import '../models/dose_event.dart';
import '../models/schedule_constraint.dart';

/// Deterministic schedule engine for the PHENO MVP.
///
/// It does not alter dose, frequency, duration, or treatment decisions.
/// Ambiguous or conflicting constraints are surfaced as conflicts instead of
/// being silently resolved.
class ScheduleEngine {
  const ScheduleEngine();

  SchedulePlan build({
    required List<MedicationSchedule> schedules,
    required DateTime from,
    required DateTime to,
  }) {
    final events = <DoseEvent>[];
    final conflicts = <ScheduleConflict>[];

    for (final schedule in schedules) {
      if (schedule.asNeeded) continue;

      final effectiveStart = _maxDate(_dateOnly(schedule.startDate), _dateOnly(from));
      final effectiveEnd = _minDate(_dateOnly(schedule.endDate), _dateOnly(to));
      if (effectiveStart.isAfter(effectiveEnd)) continue;

      final exactTimes = _exactTimes(schedule.constraints);
      final everyHoursConstraint = _everyHoursConstraint(schedule.constraints);
      final everyHours = everyHoursConstraint?.hours;

      if (exactTimes.isEmpty && everyHours == null) {
        conflicts.add(ScheduleConflict(
          medicationA: schedule.medicationName,
          medicationB: schedule.medicationName,
          reasonFa: 'زمان‌بندی این دارو مشخص نیست؛ قبل از ایجاد برنامه نیاز به تأیید دارد.',
          reasonEn: 'This medication has no explicit timing rule; confirmation is required before scheduling.',
        ));
        continue;
      }

      if (exactTimes.isNotEmpty) {
        for (var day = effectiveStart;
            !day.isAfter(effectiveEnd);
            day = day.add(const Duration(days: 1))) {
          for (final minuteOfDay in exactTimes) {
            events.add(_eventAt(schedule, day, minuteOfDay));
          }
        }
      } else if (everyHours != null && everyHours > 0) {
        // An every-X-hours rule must have an explicit anchor time. PHENO
        // never invents a first dose time.
        if (everyHoursConstraint?.minutes == null) {
          conflicts.add(ScheduleConflict(
            medicationA: schedule.medicationName,
            medicationB: schedule.medicationName,
            reasonFa: 'برای «هر X ساعت» زمان شروع مشخص نشده است؛ PHENO زمان را حدس نمی‌زند.',
            reasonEn: 'An anchor time is missing for the every-X-hours rule; PHENO will not guess one.',
          ));
          continue;
        }
        final first = _eventAt(schedule, effectiveStart, everyHoursConstraint!.minutes!).scheduledAt;
        for (var cursor = first;
            !cursor.isAfter(effectiveEnd.add(const Duration(days: 1)).subtract(const Duration(seconds: 1)));
            cursor = cursor.add(Duration(hours: everyHours))) {
          if (!cursor.isBefore(effectiveEnd.add(const Duration(days: 1)))) {
            break;
          }
          events.add(DoseEvent(
            medicationName: schedule.medicationName,
            dosage: schedule.dosage,
            scheduledAt: cursor,
          ));
        }
      }
    }

    final filteredEvents = events
        .where((event) => !event.scheduledAt.isBefore(from) && !event.scheduledAt.isAfter(to))
        .toList();
    filteredEvents.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
    return SchedulePlan(events: List.unmodifiable(filteredEvents), conflicts: List.unmodifiable(conflicts));
  }

  List<int> _exactTimes(List<ScheduleConstraint> constraints) {
    return constraints
        .where((c) => c.type == ScheduleConstraintType.exactTime && c.minutes != null)
        .map((c) => c.minutes!)
        .where((m) => m >= 0 && m < 24 * 60)
        .toList();
  }

  ScheduleConstraint? _everyHoursConstraint(List<ScheduleConstraint> constraints) {
    for (final constraint in constraints) {
      if (constraint.type == ScheduleConstraintType.everyHours && constraint.hours != null) {
        return constraint;
      }
    }
    return null;
  }

  DoseEvent _eventAt(MedicationSchedule schedule, DateTime day, int minuteOfDay) {
    final hour = minuteOfDay ~/ 60;
    final minute = minuteOfDay % 60;
    return DoseEvent(
      medicationName: schedule.medicationName,
      dosage: schedule.dosage,
      scheduledAt: DateTime(day.year, day.month, day.day, hour, minute),
      instructionFa: _instructionFa(schedule),
      instructionEn: _instructionEn(schedule),
    );
  }

  String? _instructionFa(MedicationSchedule schedule) {
    for (final c in schedule.constraints) {
      if (c.noteFa != null) return c.noteFa;
    }
    return null;
  }

  String? _instructionEn(MedicationSchedule schedule) {
    for (final c in schedule.constraints) {
      if (c.noteEn != null) return c.noteEn;
    }
    return null;
  }

  DateTime _dateOnly(DateTime value) => DateTime(value.year, value.month, value.day);

  DateTime _maxDate(DateTime a, DateTime b) => a.isAfter(b) ? a : b;
  DateTime _minDate(DateTime a, DateTime b) => a.isBefore(b) ? a : b;
}

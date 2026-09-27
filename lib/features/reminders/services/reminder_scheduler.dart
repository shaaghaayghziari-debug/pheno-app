import '../../schedule/models/dose_event.dart';
import '../../schedule/models/dose_event_record.dart';
import '../../schedule/repositories/dose_event_repository.dart';
import '../models/reminder_status.dart';

abstract interface class ReminderScheduler {
  Future<void> schedule(DoseEventRecord event);
  Future<void> cancel(String eventId);
}

/// No-op adapter used until the native iOS/Android notification provider is selected.
/// It deliberately performs no platform notification calls.
class PendingNativeReminderScheduler implements ReminderScheduler {
  @override
  Future<void> schedule(DoseEventRecord event) async {}

  @override
  Future<void> cancel(String eventId) async {}
}

class ReminderEngine {
  ReminderEngine(this._events, {ReminderScheduler? scheduler})
      : _scheduler = scheduler ?? PendingNativeReminderScheduler();

  final DoseEventRepository _events;
  final ReminderScheduler _scheduler;

  Future<List<DoseEventRecord>> refreshStatuses({required DateTime now}) async {
    final start = DateTime(now.year, now.month, now.day);
    final end = start.add(const Duration(days: 1)).subtract(const Duration(milliseconds: 1));
    final events = await _events.getRange(start, end);
    final updated = <DoseEventRecord>[];

    for (final event in events) {
      if (event.status == DoseEventStatus.taken) {
        updated.add(event);
        continue;
      }

      final lateBy = now.difference(event.scheduledAt);
      final nextStatus = lateBy >= const Duration(hours: 2)
          ? DoseEventStatus.missed
          : event.scheduledAt.isAfter(now)
              ? DoseEventStatus.upcoming
              : DoseEventStatus.upcoming;

      if (nextStatus != event.status) {
        await _events.updateStatus(event.id, nextStatus);
        updated.add(event.copyWith(status: nextStatus));
      } else {
        updated.add(event);
      }

      if (nextStatus == DoseEventStatus.upcoming &&
          event.scheduledAt.isAfter(now)) {
        await _scheduler.schedule(event);
      }
    }

    return updated;
  }
}

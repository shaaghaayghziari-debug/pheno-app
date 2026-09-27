import 'reminder_status.dart';

class ReminderRecord {
  const ReminderRecord({
    required this.eventId,
    required this.medicationId,
    required this.title,
    required this.scheduledAt,
    this.status = ReminderStatus.upcoming,
  });

  final String eventId;
  final String medicationId;
  final String title;
  final DateTime scheduledAt;
  final ReminderStatus status;

  ReminderRecord copyWith({ReminderStatus? status}) => ReminderRecord(
        eventId: eventId,
        medicationId: medicationId,
        title: title,
        scheduledAt: scheduledAt,
        status: status ?? this.status,
      );
}

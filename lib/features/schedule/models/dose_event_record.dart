import 'dose_event.dart';

class DoseEventRecord {
  const DoseEventRecord({
    required this.id,
    required this.medicationId,
    required this.medicationName,
    required this.dosage,
    required this.scheduledAt,
    this.status = DoseEventStatus.upcoming,
    this.instructionFa,
    this.instructionEn,
  });

  final String id;
  final String medicationId;
  final String medicationName;
  final String dosage;
  final DateTime scheduledAt;
  final DoseEventStatus status;
  final String? instructionFa;
  final String? instructionEn;

  DoseEventRecord copyWith({DoseEventStatus? status}) => DoseEventRecord(
        id: id,
        medicationId: medicationId,
        medicationName: medicationName,
        dosage: dosage,
        scheduledAt: scheduledAt,
        status: status ?? this.status,
        instructionFa: instructionFa,
        instructionEn: instructionEn,
      );

  Map<String, Object?> toMap() => {
        'id': id,
        'medicationId': medicationId,
        'medicationName': medicationName,
        'dosage': dosage,
        'scheduledAt': scheduledAt.toIso8601String(),
        'status': status.name,
        'instructionFa': instructionFa,
        'instructionEn': instructionEn,
      };

  factory DoseEventRecord.fromMap(Map<String, Object?> map) => DoseEventRecord(
        id: map['id'] as String,
        medicationId: map['medicationId'] as String,
        medicationName: map['medicationName'] as String,
        dosage: map['dosage'] as String,
        scheduledAt: DateTime.parse(map['scheduledAt'] as String),
        status: DoseEventStatus.values.firstWhere(
          (value) => value.name == map['status'],
          orElse: () => DoseEventStatus.upcoming,
        ),
        instructionFa: map['instructionFa'] as String?,
        instructionEn: map['instructionEn'] as String?,
      );
}

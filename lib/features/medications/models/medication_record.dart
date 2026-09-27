class MedicationRecord {
  const MedicationRecord({
    required this.id,
    required this.name,
    this.activeIngredient,
    this.dose,
    this.form,
    this.quantity,
    this.remainingQuantity,
    this.dosesPerDay = 1,
    this.scheduleTimesMinutes = const [],
    this.asNeeded = false,
    this.startDate,
    this.endDate,
  });

  final String id;
  final String name;
  final String? activeIngredient;
  final String? dose;
  final String? form;
  final int? quantity;
  final int? remainingQuantity;
  final double dosesPerDay;
  /// Explicit clock times. PHENO never derives treatment times from doses/day.
  final List<int> scheduleTimesMinutes;
  final bool asNeeded;
  final DateTime? startDate;
  final DateTime? endDate;

  MedicationRecord copyWith({
    int? remainingQuantity,
    double? dosesPerDay,
    List<int>? scheduleTimesMinutes,
  }) => MedicationRecord(
        id: id,
        name: name,
        activeIngredient: activeIngredient,
        dose: dose,
        form: form,
        quantity: quantity,
        remainingQuantity: remainingQuantity ?? this.remainingQuantity,
        dosesPerDay: dosesPerDay ?? this.dosesPerDay,
        scheduleTimesMinutes: scheduleTimesMinutes ?? this.scheduleTimesMinutes,
        asNeeded: asNeeded,
        startDate: startDate,
        endDate: endDate,
      );

  Map<String, Object?> toMap() => {
        'id': id,
        'name': name,
        'activeIngredient': activeIngredient,
        'dose': dose,
        'form': form,
        'quantity': quantity,
        'remainingQuantity': remainingQuantity,
        'dosesPerDay': dosesPerDay,
        'scheduleTimesMinutes': scheduleTimesMinutes,
        'asNeeded': asNeeded,
        'startDate': startDate?.toIso8601String(),
        'endDate': endDate?.toIso8601String(),
      };

  factory MedicationRecord.fromMap(Map<String, Object?> map) => MedicationRecord(
        id: map['id'] as String,
        name: map['name'] as String,
        activeIngredient: map['activeIngredient'] as String?,
        dose: map['dose'] as String?,
        form: map['form'] as String?,
        quantity: map['quantity'] as int?,
        remainingQuantity: map['remainingQuantity'] as int?,
        dosesPerDay: (map['dosesPerDay'] as num?)?.toDouble() ?? 1,
        scheduleTimesMinutes: ((map['scheduleTimesMinutes'] as List?) ?? const [])
            .whereType<num>()
            .map((e) => e.toInt())
            .toList(growable: false),
        asNeeded: map['asNeeded'] as bool? ?? false,
        startDate: map['startDate'] == null ? null : DateTime.tryParse(map['startDate'] as String),
        endDate: map['endDate'] == null ? null : DateTime.tryParse(map['endDate'] as String),
      );
}

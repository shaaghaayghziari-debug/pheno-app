import '../models/cabinet_item.dart';

class RefillAdvice {
  final CabinetItem item;
  final DateTime? runOutDate;
  final RefillStatus status;

  const RefillAdvice({
    required this.item,
    required this.runOutDate,
    required this.status,
  });

  bool get needsAttention =>
      status == RefillStatus.low ||
      status == RefillStatus.critical ||
      status == RefillStatus.finished;
}

class RefillEngine {
  const RefillEngine();

  List<RefillAdvice> evaluate(
    List<CabinetItem> items, {
    DateTime? now,
  }) {
    return items
        .map(
          (item) => RefillAdvice(
            item: item,
            runOutDate: item.estimatedRunOutDate(from: now),
            status: item.status(from: now),
          ),
        )
        .toList();
  }
}

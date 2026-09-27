import 'package:flutter/material.dart';
import '../../../core/theme/pheno_theme.dart';
import '../models/cabinet_item.dart';
import '../services/refill_engine.dart';
import '../../medications/repositories/medication_repository.dart';

class CabinetPage extends StatefulWidget {
  final Locale locale;
  final List<CabinetItem> items;
  final MedicationRepository? repository;

  const CabinetPage({
    super.key,
    required this.locale,
    this.items = demoCabinetItems,
    this.repository,
  });

  @override State<CabinetPage> createState() => _CabinetPageState();
}

class _CabinetPageState extends State<CabinetPage> {

  bool get isFa => widget.locale.languageCode == 'fa';
  List<CabinetItem> _items = const [];

  @override
  void initState() {
    super.initState();
    _items = widget.items;
    _load();
  }

  Future<void> _load() async {
    final repository = widget.repository;
    if (repository == null) return;
    final records = await repository.getAll();
    if (!mounted) return;
    setState(() {
      _items = records.map((record) => CabinetItem(
        medicationNameFa: record.name,
        medicationNameEn: record.name,
        dosage: record.dose ?? '',
        remainingQuantity: record.remainingQuantity ?? record.quantity ?? 0,
        dosesPerDay: record.dosesPerDay,
      )).toList(growable: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final advice = const RefillEngine().evaluate(_items);
    final attention = advice.where((item) => item.needsAttention).length;

    return Scaffold(
      appBar: AppBar(
        title: Text(isFa ? 'کابینت دارو' : 'Medication Cabinet'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          _HeaderCard(isFa: isFa, attentionCount: attention),
          const SizedBox(height: 16),
          ...advice.map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _CabinetCard(entry: entry, isFa: isFa),
              )),
          const SizedBox(height: 8),
          Text(
            isFa
                ? 'محاسبه زمان اتمام بر اساس موجودی ثبت‌شده و تعداد مصرف روزانه انجام می‌شود؛ این محاسبه تصمیم درمانی نیست.'
                : 'Run-out estimates use recorded inventory and daily dose count; they do not make treatment decisions.',
            style: const TextStyle(fontSize: 12, color: PhenoColors.warmGray),
          ),
        ],
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final bool isFa;
  final int attentionCount;

  const _HeaderCard({required this.isFa, required this.attentionCount});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: PhenoColors.ivory,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: PhenoColors.sageSoft,
              child: Icon(Icons.inventory_2_outlined, color: PhenoColors.burgundy),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isFa ? 'وضعیت موجودی' : 'Inventory status',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    attentionCount == 0
                        ? (isFa ? 'همه‌چیز تحت کنترل است' : 'Everything is on track')
                        : (isFa ? '$attentionCount دارو نیاز به توجه دارد' : '$attentionCount medications need attention'),
                    style: const TextStyle(color: PhenoColors.warmGray),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CabinetCard extends StatelessWidget {
  final RefillAdvice entry;
  final bool isFa;

  const _CabinetCard({required this.entry, required this.isFa});

  String _statusLabel() {
    switch (entry.status) {
      case RefillStatus.healthy:
        return isFa ? 'کافی' : 'Healthy';
      case RefillStatus.low:
        return isFa ? 'رو به اتمام' : 'Low';
      case RefillStatus.critical:
        return isFa ? 'خیلی کم' : 'Critical';
      case RefillStatus.finished:
        return isFa ? 'تمام شده' : 'Finished';
      case RefillStatus.unknown:
        return isFa ? 'نامشخص' : 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    final runOut = entry.runOutDate;
    final runOutText = runOut == null
        ? (isFa ? 'تاریخ قابل محاسبه نیست' : 'Run-out date unavailable')
        : '${runOut.year}/${runOut.month.toString().padLeft(2, '0')}/${runOut.day.toString().padLeft(2, '0')}';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(entry.item.name(isFa), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                      const SizedBox(height: 3),
                      Text(entry.item.dosage, style: const TextStyle(color: PhenoColors.warmGray)),
                    ],
                  ),
                ),
                _StatusPill(label: _statusLabel(), status: entry.status),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(child: _Metric(label: isFa ? 'باقی‌مانده' : 'Remaining', value: '${entry.item.remainingQuantity}')),
                Expanded(child: _Metric(label: isFa ? 'مصرف روزانه' : 'Daily doses', value: '${entry.item.dosesPerDay}')),
                Expanded(child: _Metric(label: isFa ? 'اتمام تقریبی' : 'Estimated end', value: runOutText)),
              ],
            ),
            if (entry.needsAttention) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add_shopping_cart_outlined),
                  label: Text(isFa ? 'تهیه مجدد' : 'Refill'),
                  style: FilledButton.styleFrom(backgroundColor: PhenoColors.burgundy),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final String label;
  final String value;
  const _Metric({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: PhenoColors.warmGray)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
      ],
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String label;
  final RefillStatus status;
  const _StatusPill({required this.label, required this.status});

  @override
  Widget build(BuildContext context) {
    final isHealthy = status == RefillStatus.healthy;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isHealthy ? PhenoColors.sageSoft : PhenoColors.cream,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: isHealthy ? PhenoColors.sage : PhenoColors.burgundy)),
    );
  }
}

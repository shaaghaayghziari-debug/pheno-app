import 'package:flutter/material.dart';
import '../../../core/theme/pheno_theme.dart';
import '../../medication/models/medication.dart';

class SafetyCenterPage extends StatelessWidget {
  final Medication medication;
  final bool isFa;

  const SafetyCenterPage({super.key, required this.medication, required this.isFa});

  String get _title => isFa ? 'مرکز ایمنی دارو' : 'Medication Safety Center';
  String get _intro => isFa
      ? 'PHENO اطلاعات ایمنی را نمایش می‌دهد؛ تصمیم درمانی را جایگزین پزشک یا داروساز نمی‌کند.'
      : 'PHENO surfaces safety information; it does not replace a doctor or pharmacist for treatment decisions.';

  @override
  Widget build(BuildContext context) {
    final items = medication.safetyItems;
    return Scaffold(
      appBar: AppBar(title: Text(_title)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            Card(
              color: PhenoColors.sageSoft,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.verified_user_outlined, color: PhenoColors.sage, size: 28),
                    const SizedBox(width: 12),
                    Expanded(child: Text(_intro, style: const TextStyle(fontWeight: FontWeight.w600, height: 1.45))),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(isFa ? 'موارد قابل بررسی' : 'Safety checks', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            if (items.isEmpty)
              _EmptyState(isFa: isFa)
            else
              ...items.map((item) => Padding(padding: const EdgeInsets.only(bottom: 12), child: _SafetyCard(item: item, isFa: isFa))),
            const SizedBox(height: 8),
            _Footer(isFa: isFa),
          ],
        ),
      ),
    );
  }
}

class _SafetyCard extends StatelessWidget {
  final SafetyItem item;
  final bool isFa;
  const _SafetyCard({required this.item, required this.isFa});

  @override
  Widget build(BuildContext context) {
    final (icon, label) = switch (item.severity) {
      SafetySeverity.info => (Icons.info_outline, isFa ? 'اطلاعات' : 'Information'),
      SafetySeverity.caution => (Icons.warning_amber_rounded, isFa ? 'توجه' : 'Caution'),
      SafetySeverity.urgent => (Icons.priority_high_rounded, isFa ? 'نیازمند اقدام' : 'Action needed'),
    };
    final color = switch (item.severity) {
      SafetySeverity.info => PhenoColors.sage,
      SafetySeverity.caution => PhenoColors.warning,
      SafetySeverity.urgent => PhenoColors.danger,
    };
    final evidence = switch (item.evidenceLevel) {
      EvidenceLevel.high => isFa ? 'شواهد قوی' : 'High evidence',
      EvidenceLevel.moderate => isFa ? 'شواهد متوسط' : 'Moderate evidence',
      EvidenceLevel.limited => isFa ? 'شواهد محدود' : 'Limited evidence',
      EvidenceLevel.unavailable => isFa ? 'سطح شواهد مشخص نیست' : 'Evidence level unavailable',
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(icon, color: color),
            const SizedBox(width: 10),
            Expanded(child: Text(item.title(isFa), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16))),
            Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w700)),
          ]),
          const SizedBox(height: 10),
          Text(item.detail(isFa), style: const TextStyle(height: 1.45)),
          const SizedBox(height: 10),
          Text(evidence, style: const TextStyle(color: PhenoColors.warmGray, fontSize: 12)),
        ]),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool isFa;
  const _EmptyState({required this.isFa});
  @override
  Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.all(18), child: Text(isFa ? 'اطلاعات ایمنی کافی برای نمایش ثبت نشده است.' : 'There is not enough structured safety information to display.')));
}

class _Footer extends StatelessWidget {
  final bool isFa;
  const _Footer({required this.isFa});
  @override
  Widget build(BuildContext context) => Text(isFa ? 'برای علائم شدید، واکنش حساسیتی یا نگرانی فوری، از خدمات پزشکی مناسب کمک بگیرید.' : 'For severe symptoms, an allergic reaction, or an urgent concern, seek appropriate medical care.', style: const TextStyle(color: PhenoColors.warmGray, height: 1.45));
}

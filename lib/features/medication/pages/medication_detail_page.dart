import 'package:flutter/material.dart';
import '../../../core/theme/pheno_theme.dart';
import '../models/medication.dart';
import '../../safety/pages/safety_center_page.dart';

class MedicationDetailPage extends StatelessWidget {
  final Medication medication;
  final bool isFa;

  const MedicationDetailPage({super.key, required this.medication, required this.isFa});

  String get _howToTake => isFa ? 'روش صحیح مصرف' : 'How to take';
  String get _foodAbsorption => isFa ? 'غذا و جذب' : 'Food & absorption';
  String get _safety => isFa ? 'ایمنی' : 'Safety';
  String get _nextDose => isFa ? 'دوز بعدی' : 'Next dose';
  String get _remaining => isFa ? 'موجودی' : 'Remaining';

  @override
  Widget build(BuildContext context) {
    final interactions = medication.interactions(isFa);
    final warnings = medication.warnings(isFa);
    final guidance = medication.foodGuidance;

    return Scaffold(
      appBar: AppBar(
        title: Text(isFa ? 'جزئیات دارو' : 'Medication details'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            _Header(medication: medication, isFa: isFa),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _MetricCard(label: _nextDose, value: medication.nextDose, icon: Icons.schedule_outlined)),
                const SizedBox(width: 12),
                Expanded(child: _MetricCard(label: _remaining, value: '${medication.remainingQuantity} / ${medication.quantity}', icon: Icons.inventory_2_outlined)),
              ],
            ),
            const SizedBox(height: 16),
            _SectionCard(
              icon: Icons.medication_outlined,
              title: _howToTake,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(medication.instruction(isFa), style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                _InfoLine(Icons.repeat, isFa ? medication.frequencyFa : medication.frequencyEn),
                _InfoLine(Icons.calendar_today_outlined, isFa ? medication.durationFa : medication.durationEn),
              ]),
            ),
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => SafetyCenterPage(medication: medication, isFa: isFa)),
              ),
              icon: const Icon(Icons.verified_user_outlined),
              label: Text(isFa ? 'مشاهده مرکز ایمنی' : 'Open safety center'),
              style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
            ),
            const SizedBox(height: 14),
            _SectionCard(
              icon: Icons.restaurant_outlined,
              title: _foodAbsorption,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                if (guidance.timingFa != null)
                  _InfoLine(Icons.access_time_outlined, isFa ? guidance.timingFa! : guidance.timingEn!),
                if (guidance.helpfulFa != null) ...[
                  const SizedBox(height: 8),
                  _GuidanceLine(icon: Icons.add_circle_outline, label: isFa ? 'ممکن است جذب را افزایش دهد' : 'May improve absorption', text: isFa ? guidance.helpfulFa! : guidance.helpfulEn!),
                ],
                if (guidance.reduceFa != null) ...[
                  const SizedBox(height: 8),
                  _GuidanceLine(icon: Icons.remove_circle_outline, label: isFa ? 'ممکن است جذب را کاهش دهد' : 'May reduce absorption', text: isFa ? guidance.reduceFa! : guidance.reduceEn!),
                ],
              ]),
            ),
            const SizedBox(height: 14),
            _SectionCard(
              icon: Icons.shield_outlined,
              title: _safety,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                if (interactions.isNotEmpty) ...interactions.map((text) => _SafetyLine(text: text, icon: Icons.sync_problem_outlined)),
                if (warnings.isNotEmpty) ...[
                  if (interactions.isNotEmpty) const SizedBox(height: 8),
                  ...warnings.map((text) => _SafetyLine(text: text, icon: Icons.info_outline)),
                ],
                const SizedBox(height: 8),
                Text(
                  isFa ? 'اطلاعات ایمنی جایگزین تصمیم پزشک یا داروساز نیست.' : 'Safety information does not replace advice from your doctor or pharmacist.',
                  style: const TextStyle(fontSize: 12, color: PhenoColors.warmGray),
                ),
              ]),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.check),
              label: Text(isFa ? 'مصرف شد' : 'Mark as taken'),
              style: FilledButton.styleFrom(
                backgroundColor: PhenoColors.burgundy,
                minimumSize: const Size.fromHeight(52),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final Medication medication;
  final bool isFa;
  const _Header({required this.medication, required this.isFa});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(children: [
          const CircleAvatar(radius: 28, backgroundColor: PhenoColors.sageSoft, child: Icon(Icons.medication_outlined, color: PhenoColors.burgundy, size: 28)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(medication.name(isFa), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text('${medication.dosage} · ${medication.form(isFa)}', style: const TextStyle(color: PhenoColors.warmGray)),
            const SizedBox(height: 3),
            Text(medication.activeIngredient(isFa), style: const TextStyle(fontSize: 12, color: PhenoColors.warmGray)),
          ])),
        ]),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _MetricCard({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Icon(icon, color: PhenoColors.burgundy, size: 22),
    const SizedBox(height: 10),
    Text(label, style: const TextStyle(fontSize: 12, color: PhenoColors.warmGray)),
    const SizedBox(height: 3),
    Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
  ])));
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;
  const _SectionCard({required this.icon, required this.title, required this.child});

  @override
  Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Row(children: [Icon(icon, color: PhenoColors.burgundy, size: 21), const SizedBox(width: 8), Text(title, style: const TextStyle(fontWeight: FontWeight.w800))]),
    const SizedBox(height: 14),
    child,
  ])));
}

class _InfoLine extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoLine(this.icon, this.text);
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(children: [Icon(icon, size: 17, color: PhenoColors.warmGray), const SizedBox(width: 8), Expanded(child: Text(text))]));
}

class _GuidanceLine extends StatelessWidget {
  final IconData icon;
  final String label;
  final String text;
  const _GuidanceLine({required this.icon, required this.label, required this.text});
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: PhenoColors.sageSoft, borderRadius: BorderRadius.circular(14)), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, size: 19, color: PhenoColors.sage), const SizedBox(width: 8), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(fontWeight: FontWeight.w700)), const SizedBox(height: 3), Text(text, style: const TextStyle(fontSize: 13))]))]));
}

class _SafetyLine extends StatelessWidget {
  final IconData icon;
  final String text;
  const _SafetyLine({required this.icon, required this.text});
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, size: 18, color: PhenoColors.warning), const SizedBox(width: 8), Expanded(child: Text(text))]));
}

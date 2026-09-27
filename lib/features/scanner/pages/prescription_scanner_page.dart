import 'package:flutter/material.dart';
import '../../../core/theme/pheno_theme.dart';
import '../models/prescription_scan.dart';
import '../services/prescription_ocr_service.dart';

class PrescriptionScannerPage extends StatefulWidget {
  const PrescriptionScannerPage({super.key, required this.isFa});
  final bool isFa;

  @override
  State<PrescriptionScannerPage> createState() => _PrescriptionScannerPageState();
}

class _PrescriptionScannerPageState extends State<PrescriptionScannerPage> {
  final _ocr = PrescriptionOcrService();
  PrescriptionScan _scan = const PrescriptionScan(status: ScanStatus.idle);

  Future<void> _analyze() async {
    setState(() => _scan = const PrescriptionScan(status: ScanStatus.analyzing));
    final result = await _ocr.analyzePlaceholder();
    if (mounted) setState(() => _scan = result);
  }

  @override
  Widget build(BuildContext context) {
    final fa = widget.isFa;
    return Scaffold(
      appBar: AppBar(title: Text(fa ? 'اسکن نسخه' : 'Scan Prescription')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        children: [
          _Header(fa: fa),
          const SizedBox(height: 16),
          _ScannerCard(scan: _scan, fa: fa, onAnalyze: _analyze),
          if (_scan.status == ScanStatus.review) ...[
            const SizedBox(height: 18),
            _ReviewSection(scan: _scan, fa: fa),
          ],
          const SizedBox(height: 18),
          _SafetyNote(fa: fa),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.fa});
  final bool fa;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(fa ? 'نسخه را به برنامه مصرف تبدیل کن' : 'Turn a prescription into a medication plan', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
      const SizedBox(height: 6),
      Text(fa ? 'PHENO متن نسخه را می‌خواند؛ موارد نامطمئن را برای تأیید به تو نشان می‌دهد.' : 'PHENO reads the prescription and surfaces uncertain fields for your confirmation.'),
    ],
  );
}

class _ScannerCard extends StatelessWidget {
  const _ScannerCard({required this.scan, required this.fa, required this.onAnalyze});
  final PrescriptionScan scan;
  final bool fa;
  final VoidCallback onAnalyze;

  @override
  Widget build(BuildContext context) {
    final analyzing = scan.status == ScanStatus.analyzing;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: PhenoColors.ivory, borderRadius: BorderRadius.circular(24)),
      child: Column(children: [
        Container(
          height: 180,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), border: Border.all(color: PhenoColors.warmGray)),
          child: Center(child: Icon(analyzing ? Icons.document_scanner : Icons.camera_alt_outlined, size: 54, color: PhenoColors.burgundy)),
        ),
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: analyzing ? null : onAnalyze,
            icon: analyzing ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.auto_awesome),
            label: Text(analyzing ? (fa ? 'در حال تحلیل…' : 'Analyzing…') : (fa ? 'تحلیل نسخه' : 'Analyze prescription')),
          ),
        ),
      ]),
    );
  }
}

class _ReviewSection extends StatelessWidget {
  const _ReviewSection({required this.scan, required this.fa});
  final PrescriptionScan scan;
  final bool fa;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(fa ? 'بررسی قبل از تأیید' : 'Review before confirmation', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
      const SizedBox(height: 10),
      ...scan.medications.map((med) => _MedicationDraftCard(med: med, fa: fa)),
      const SizedBox(height: 10),
      SizedBox(width: double.infinity, child: FilledButton(
        onPressed: scan.hasUncertainFields ? null : () {},
        child: Text(fa ? 'تأیید و ساخت برنامه مصرف' : 'Confirm & create medication plan'),
      )),
      if (scan.hasUncertainFields) Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(fa ? 'ابتدا مواردی که با برچسب «نیازمند بررسی» مشخص شده‌اند را تأیید کنید.' : 'Confirm fields marked “Needs review” first.', style: const TextStyle(color: PhenoColors.warning)),
      ),
    ]);
  }
}

class _MedicationDraftCard extends StatelessWidget {
  const _MedicationDraftCard({required this.med, required this.fa});
  final PrescriptionMedicationDraft med;
  final bool fa;

  @override
  Widget build(BuildContext context) {
    final fields = <String, PrescriptionField<String>>{
      fa ? 'نام دارو' : 'Medication': med.name,
      fa ? 'دوز' : 'Dose': med.dose,
      fa ? 'شکل دارویی' : 'Form': med.form,
      fa ? 'فاصله مصرف' : 'Frequency': med.frequency,
      fa ? 'مدت' : 'Duration': med.duration,
      fa ? 'دستور مصرف' : 'Instructions': med.instruction,
    };
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(padding: const EdgeInsets.all(16), child: Column(children: fields.entries.map((e) {
        final uncertain = e.value.needsConfirmation;
        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(e.key),
          subtitle: Text(e.value.value, style: const TextStyle(fontWeight: FontWeight.w600)),
          trailing: uncertain ? const Chip(label: Text('Review')) : const Icon(Icons.check_circle_outline),
        );
      }).toList())),
    );
  }
}

class _SafetyNote extends StatelessWidget {
  const _SafetyNote({required this.fa});
  final bool fa;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: PhenoColors.sageSoft, borderRadius: BorderRadius.circular(18)),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Icon(Icons.verified_user_outlined, color: PhenoColors.sage),
      const SizedBox(width: 10),
      Expanded(child: Text(fa ? 'PHENO تصمیم درمانی نمی‌گیرد. نسخه و موارد نامطمئن باید توسط کاربر و در صورت نیاز پزشک یا داروساز بررسی شوند.' : 'PHENO does not make treatment decisions. Review uncertain prescription details and consult a clinician or pharmacist when needed.')),
    ]),
  );
}

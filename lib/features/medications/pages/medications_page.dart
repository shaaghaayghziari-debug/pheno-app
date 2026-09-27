import 'package:flutter/material.dart';
import '../../../core/theme/pheno_theme.dart';
import '../models/medication_record.dart';
import '../repositories/medication_repository.dart';

class MedicationsPage extends StatefulWidget {
  final Locale locale;
  final MedicationRepository repository;
  const MedicationsPage({super.key, required this.locale, required this.repository});
  @override State<MedicationsPage> createState() => _MedicationsPageState();
}

class _MedicationsPageState extends State<MedicationsPage> {
  List<MedicationRecord> _items = const [];
  bool _loading = true;
  bool get isFa => widget.locale.languageCode == 'fa';

  @override void initState() { super.initState(); _load(); }
  Future<void> _load() async { final items = await widget.repository.getAll(); if (mounted) setState(() { _items = items; _loading = false; }); }

  Future<void> _addMedication() async {
    final result = await showDialog<MedicationRecord>(context: context, builder: (_) => _AddMedicationDialog(isFa: isFa));
    if (result == null) return;
    await widget.repository.save(result);
    await _load();
  }

  Future<void> _adjustRemaining(MedicationRecord item) async {
    final controller = TextEditingController(text: '${item.remainingQuantity ?? item.quantity ?? 0}');
    final value = await showDialog<int>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isFa ? 'به‌روزرسانی موجودی' : 'Update inventory'),
        content: TextField(controller: controller, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: isFa ? 'تعداد باقی‌مانده' : 'Remaining quantity')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(isFa ? 'انصراف' : 'Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, int.tryParse(controller.text)), child: Text(isFa ? 'ذخیره' : 'Save')),
        ],
      ),
    );
    controller.dispose();
    if (value == null || value < 0) return;
    await widget.repository.save(item.copyWith(remainingQuantity: value));
    await _load();
  }

  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(isFa ? 'داروهای من' : 'My Medications')),
    floatingActionButton: FloatingActionButton.extended(backgroundColor: PhenoColors.burgundy, foregroundColor: Colors.white, onPressed: _addMedication, icon: const Icon(Icons.add), label: Text(isFa ? 'افزودن دارو' : 'Add medication')),
    body: _loading ? const Center(child: CircularProgressIndicator()) : _items.isEmpty ? _EmptyState(isFa: isFa, onAdd: _addMedication) : ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 100), itemCount: _items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, index) { final item = _items[index]; return Card(child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: const CircleAvatar(backgroundColor: PhenoColors.sageSoft, child: Icon(Icons.medication_outlined, color: PhenoColors.burgundy)),
        title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Padding(padding: const EdgeInsets.only(top: 5), child: Text('${item.dose ?? ''}${item.form == null ? '' : ' · ${item.form}'}\n${isFa ? 'باقی‌مانده' : 'Remaining'}: ${item.remainingQuantity ?? item.quantity ?? '—'}')),
        isThreeLine: true,
        trailing: IconButton(icon: const Icon(Icons.inventory_2_outlined), tooltip: isFa ? 'موجودی' : 'Inventory', onPressed: () => _adjustRemaining(item)),
      )); },
    ),
  );
}

class _EmptyState extends StatelessWidget {
  final bool isFa; final VoidCallback onAdd;
  const _EmptyState({required this.isFa, required this.onAdd});
  @override Widget build(BuildContext context) => Center(child: Padding(padding: const EdgeInsets.all(28), child: Column(mainAxisSize: MainAxisSize.min, children: [
    const Icon(Icons.medication_outlined, size: 48, color: PhenoColors.burgundy), const SizedBox(height: 14),
    Text(isFa ? 'هنوز دارویی ثبت نشده' : 'No medications yet', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)), const SizedBox(height: 8),
    Text(isFa ? 'اولین دارو را اضافه کنید تا PHENO بتواند آن را در لیست داروها و کابینت شما نگه دارد.' : 'Add your first medication so PHENO can keep it in your medication list and cabinet.', textAlign: TextAlign.center), const SizedBox(height: 18),
    FilledButton.icon(onPressed: onAdd, icon: const Icon(Icons.add), label: Text(isFa ? 'افزودن دارو' : 'Add medication')),
  ])));
}

class _AddMedicationDialog extends StatefulWidget {
  final bool isFa; const _AddMedicationDialog({required this.isFa});
  @override State<_AddMedicationDialog> createState() => _AddMedicationDialogState();
}
class _AddMedicationDialogState extends State<_AddMedicationDialog> {
  final _name = TextEditingController(), _dose = TextEditingController(), _form = TextEditingController(), _quantity = TextEditingController(), _dosesPerDay = TextEditingController(text: '1'), _times = TextEditingController();
  @override void dispose() { _name.dispose(); _dose.dispose(); _form.dispose(); _quantity.dispose(); _dosesPerDay.dispose(); _times.dispose(); super.dispose(); }
  void _save() {
    final name = _name.text.trim(); final quantity = int.tryParse(_quantity.text.trim()); final doses = double.tryParse(_dosesPerDay.text.trim());
    final times = _times.text.split(',').map((raw) { final parts = raw.trim().split(':'); if (parts.length != 2) return -1; final h = int.tryParse(parts[0]); final m = int.tryParse(parts[1]); if (h == null || m == null || h < 0 || h > 23 || m < 0 || m > 59) return -1; return h * 60 + m; }).where((v) => v >= 0).toList();
    if (name.isEmpty || quantity == null || quantity < 0 || doses == null || doses <= 0) return;
    Navigator.pop(context, MedicationRecord(id: DateTime.now().microsecondsSinceEpoch.toString(), name: name, dose: _dose.text.trim().isEmpty ? null : _dose.text.trim(), form: _form.text.trim().isEmpty ? null : _form.text.trim(), quantity: quantity, remainingQuantity: quantity, dosesPerDay: doses, scheduleTimesMinutes: times));
  }
  @override Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.isFa ? 'داروی جدید' : 'New medication'),
    content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
      TextField(controller: _name, decoration: InputDecoration(labelText: widget.isFa ? 'نام دارو *' : 'Medication name *')),
      TextField(controller: _dose, decoration: InputDecoration(labelText: widget.isFa ? 'دوز' : 'Dose')),
      TextField(controller: _form, decoration: InputDecoration(labelText: widget.isFa ? 'شکل دارویی' : 'Form')),
      TextField(controller: _quantity, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: widget.isFa ? 'تعداد' : 'Quantity')),
      TextField(controller: _dosesPerDay, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: InputDecoration(labelText: widget.isFa ? 'تعداد مصرف در روز' : 'Doses per day')),
      TextField(controller: _times, decoration: InputDecoration(labelText: widget.isFa ? 'ساعت‌های دقیق مصرف' : 'Exact dose times', hintText: '08:00, 20:00')),
      Text(widget.isFa ? 'برای ساخت برنامه، ساعت دقیق را وارد کنید؛ PHENO از روی «تعداد در روز» زمان را حدس نمی‌زند.' : 'Enter explicit clock times; PHENO never guesses times from doses per day.', style: const TextStyle(fontSize: 12, color: PhenoColors.warmGray)),
      const SizedBox(height: 10), Text(widget.isFa ? 'این فرم فقط داده را ثبت می‌کند و تصمیم درمانی یا تغییر دوز انجام نمی‌دهد.' : 'This form records data only; it does not make treatment decisions or change doses.', style: const TextStyle(fontSize: 12, color: PhenoColors.warmGray)),
    ])),
    actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text(widget.isFa ? 'انصراف' : 'Cancel')), FilledButton(onPressed: _save, child: Text(widget.isFa ? 'ثبت دارو' : 'Save medication'))],
  );
}

import 'package:flutter/material.dart';
import '../../../core/theme/pheno_theme.dart';
import '../../medications/repositories/medication_repository.dart';
import '../models/dose_event.dart';
import '../models/dose_event_record.dart';
import '../repositories/dose_event_repository.dart';
import '../services/medication_schedule_service.dart';
import '../../reminders/pages/reminder_center_page.dart';

class SchedulePage extends StatefulWidget {
  final Locale locale;
  final MedicationRepository medicationRepository;
  final DoseEventRepository eventRepository;
  const SchedulePage({super.key, required this.locale, required this.medicationRepository, required this.eventRepository});
  @override State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  late final MedicationScheduleService _service = MedicationScheduleService(widget.eventRepository);
  List<DoseEventRecord> _events = const [];
  bool _loading = true;
  bool _hasConflicts = false;
  bool get fa => widget.locale.languageCode == 'fa';

  @override void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => _loading = true);
    final now = DateTime.now();
    final from = DateTime(now.year, now.month, now.day);
    final to = from.add(const Duration(days: 1)).subtract(const Duration(milliseconds: 1));
    final medications = await widget.medicationRepository.getAll();
    final plan = await _service.buildAndPersist(medications: medications, from: from, to: to);
    final events = await widget.eventRepository.getRange(from, to);
    if (!mounted) return;
    setState(() { _events = events; _hasConflicts = plan.hasConflicts; _loading = false; });
  }

  Future<void> _markTaken(DoseEventRecord event) async {
    if (event.status == DoseEventStatus.taken) return;
    final consumed = await widget.medicationRepository.consumeOne(event.medicationId);
    if (!consumed) return;
    await widget.eventRepository.updateStatus(event.id, DoseEventStatus.taken);
    await _load();
  }

  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(fa ? 'برنامه مصرف' : 'Medication Schedule')),
    body: _loading ? const Center(child: CircularProgressIndicator()) : RefreshIndicator(
      onRefresh: _load,
      child: ListView(padding: const EdgeInsets.fromLTRB(20, 8, 20, 32), children: [
        Text(fa ? 'برنامه امروز' : "Today's schedule", style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Text(fa ? 'Dose Eventها از ساعت‌های صریح ثبت‌شده ساخته می‌شوند.' : 'Dose Events are generated only from explicitly recorded times.', style: const TextStyle(color: PhenoColors.warmGray)),
        if (_hasConflicts) ...[
          const SizedBox(height: 14),
          Card(color: const Color(0xFFFFF5E6), child: Padding(padding: const EdgeInsets.all(16), child: Text(fa ? 'یک یا چند مورد برای زمان‌بندی نیاز به بررسی دارند؛ PHENO زمان را حدس نمی‌زند.' : 'One or more medications need schedule review; PHENO will not guess missing times.'))),
        ],
        const SizedBox(height: 16),
        Card(color: PhenoColors.sageSoft, child: ListTile(leading: const Icon(Icons.notifications_none, color: PhenoColors.burgundy), title: Text(fa ? 'مرکز یادآوری' : 'Reminder Center', style: const TextStyle(fontWeight: FontWeight.w700)), subtitle: Text(fa ? 'وضعیت Upcoming / Taken / Missed' : 'Upcoming / Taken / Missed status'), trailing: const Icon(Icons.chevron_right), onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ReminderCenterPage(locale: widget.locale, repository: widget.eventRepository))))),
        const SizedBox(height: 12),
        if (_events.isEmpty) Card(child: Padding(padding: const EdgeInsets.all(20), child: Text(fa ? 'برای امروز Dose Event ثبت نشده است.' : 'No Dose Events are scheduled for today.'))),
        ..._events.map((event) => _EventCard(event: event, fa: fa, onTaken: () => _markTaken(event))),
      ]),
    ),
  );
}

class _EventCard extends StatelessWidget {
  final DoseEventRecord event; final bool fa; final VoidCallback onTaken;
  const _EventCard({required this.event, required this.fa, required this.onTaken});
  @override Widget build(BuildContext context) {
    final time = '${event.scheduledAt.hour.toString().padLeft(2, '0')}:${event.scheduledAt.minute.toString().padLeft(2, '0')}';
    final taken = event.status == DoseEventStatus.taken;
    return Padding(padding: const EdgeInsets.only(bottom: 10), child: Card(child: Padding(padding: const EdgeInsets.all(16), child: Row(children: [
      SizedBox(width: 58, child: Text(time, style: const TextStyle(fontWeight: FontWeight.w800, color: PhenoColors.burgundy))),
      const SizedBox(width: 8), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(event.medicationName, style: const TextStyle(fontWeight: FontWeight.w700)), const SizedBox(height: 3), Text(event.dosage, style: const TextStyle(color: PhenoColors.warmGray)), if ((fa ? event.instructionFa : event.instructionEn) != null) Text(fa ? event.instructionFa! : event.instructionEn!, style: const TextStyle(fontSize: 12, color: PhenoColors.warmGray))])),
      taken ? const Icon(Icons.check_circle, color: PhenoColors.sage) : IconButton(onPressed: onTaken, icon: const Icon(Icons.radio_button_unchecked), tooltip: fa ? 'مصرف شد' : 'Mark as taken'),
    ]))));
  }
}

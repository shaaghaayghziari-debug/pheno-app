import 'package:flutter/material.dart';
import '../../../core/theme/pheno_theme.dart';
import '../../schedule/models/dose_event.dart';
import '../../schedule/models/dose_event_record.dart';
import '../../schedule/repositories/dose_event_repository.dart';
import '../services/reminder_scheduler.dart';

class ReminderCenterPage extends StatefulWidget {
  const ReminderCenterPage({super.key, required this.locale, required this.repository});
  final Locale locale;
  final DoseEventRepository repository;

  @override
  State<ReminderCenterPage> createState() => _ReminderCenterPageState();
}

class _ReminderCenterPageState extends State<ReminderCenterPage> {
  late final ReminderEngine _engine = ReminderEngine(widget.repository);
  List<DoseEventRecord> _events = const [];
  bool _loading = true;
  bool get fa => widget.locale.languageCode == 'fa';

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => _loading = true);
    final now = DateTime.now();
    final events = await _engine.refreshStatuses(now: now);
    if (!mounted) return;
    setState(() { _events = events; _loading = false; });
  }

  String _status(DoseEventStatus status) => switch (status) {
    DoseEventStatus.taken => fa ? 'مصرف شد' : 'Taken',
    DoseEventStatus.missed => fa ? 'از دست رفته' : 'Missed',
    DoseEventStatus.upcoming => fa ? 'در انتظار' : 'Upcoming',
  };

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(fa ? 'یادآوری‌ها' : 'Reminders')),
    body: _loading ? const Center(child: CircularProgressIndicator()) : RefreshIndicator(
      onRefresh: _load,
      child: ListView(padding: const EdgeInsets.all(20), children: [
        Text(fa ? 'وضعیت مصرف امروز' : "Today's medication status", style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Text(fa ? 'یادآوری‌ها از Dose Eventهای تأییدشده ساخته می‌شوند.' : 'Reminders are derived from confirmed Dose Events.', style: const TextStyle(color: PhenoColors.warmGray)),
        const SizedBox(height: 16),
        if (_events.isEmpty) Card(child: Padding(padding: const EdgeInsets.all(20), child: Text(fa ? 'برای امروز یادآوری‌ای وجود ندارد.' : 'No reminders for today.'))),
        ..._events.map((e) => Card(margin: const EdgeInsets.only(bottom: 10), child: ListTile(
          leading: Icon(e.status == DoseEventStatus.taken ? Icons.check_circle : e.status == DoseEventStatus.missed ? Icons.warning_amber_rounded : Icons.notifications_none, color: e.status == DoseEventStatus.missed ? PhenoColors.danger : PhenoColors.burgundy),
          title: Text(e.medicationName, style: const TextStyle(fontWeight: FontWeight.w700)),
          subtitle: Text('${e.scheduledAt.hour.toString().padLeft(2, '0')}:${e.scheduledAt.minute.toString().padLeft(2, '0')}  •  ${_status(e.status)}'),
        ))),
      ]),
    ),
  );
}

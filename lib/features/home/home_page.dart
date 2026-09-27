import 'package:flutter/material.dart';
import '../../core/localization/app_strings.dart';
import '../../core/theme/pheno_theme.dart';
import '../security/pages/privacy_page.dart';
import '../security/services/auth_service.dart';
import '../profile/pages/profile_page.dart';
import '../../core/security/secure_storage.dart';
import '../../core/data/local_store.dart';
import '../../core/data/sync_repository.dart';
import '../medications/pages/medications_page.dart';
import '../medications/repositories/medication_repository.dart';
import '../cabinet/pages/cabinet_page.dart';
import '../schedule/pages/schedule_page.dart';
import '../schedule/repositories/dose_event_repository.dart';
import '../scanner/pages/prescription_scanner_page.dart';
import '../safety/pages/safety_center_page.dart';
import '../clinical/pages/clinical_source_page.dart';
import '../pharmacy/pages/pharmacy_phase2_page.dart';
import '../../core/widgets/founder_signature.dart';

class HomePage extends StatelessWidget {
  final Locale locale;
  final ValueChanged<Locale> onLocaleChanged;

  static final AuthService _authService = PendingAuthService(storage: InMemorySecureStorage());
  static final MemoryLocalStore _store = MemoryLocalStore();
  static final MedicationRepository _medicationRepository = MedicationRepository(_store);
  static final DoseEventRepository _doseEventRepository = DoseEventRepository(_store);

  const HomePage({super.key, required this.locale, required this.onLocaleChanged});

  @override
  Widget build(BuildContext context) {
    final s = AppStrings(locale);
    return Scaffold(
      appBar: AppBar(
        title: const Text('PHENO', style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 4)),
        actions: [
          TextButton(onPressed: () => onLocaleChanged(locale.languageCode == 'fa' ? const Locale('en') : const Locale('fa')), child: Text(locale.languageCode == 'fa' ? 'EN' : 'فا')),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          children: [
            Text(s.greeting, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700, color: PhenoColors.charcoal)),
            const SizedBox(height: 4),
            Text(s.tagline, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: PhenoColors.warmGray)),
            const SizedBox(height: 20),
            Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(s.isFa ? 'امروز' : 'Today', style: const TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              Text(s.isFa ? 'PHENO آماده است تا نسخه، برنامه مصرف، ایمنی و کابینت دارو را در یک جریان منسجم کنار هم قرار دهد.' : 'PHENO is designed to bring prescription understanding, scheduling, safety, and medication inventory into one flow.', style: const TextStyle(height: 1.5)),
            ]))),
            const SizedBox(height: 16),
            _HomeAction(
              icon: Icons.document_scanner_outlined,
              title: s.isFa ? 'اسکن نسخه' : 'Scan Prescription',
              subtitle: s.isFa ? 'نسخه را بخوان، بررسی کن و قبل از تأیید برنامه بساز' : 'Read, review, and confirm before creating a medication plan',
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => PrescriptionScannerPage(isFa: s.isFa))),
            ),
            const SizedBox(height: 10),
            _HomeAction(
              icon: Icons.verified_user_outlined,
              title: s.isFa ? 'مرکز ایمنی و منابع' : 'Safety & Clinical Sources',
              subtitle: s.isFa ? 'اطلاعات ایمنی، شواهد و منابع معتبر' : 'Safety information, evidence, and source boundaries',
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ClinicalSourcePage(isFa: s.isFa))),
            ),
            const SizedBox(height: 10),
            _HomeAction(
              icon: Icons.storefront_outlined,
              title: s.isFa ? 'یافتن داروخانه — مرحله ۲' : 'Find a Pharmacy — Phase 2',
              subtitle: s.isFa ? 'اتصال موجودی و رزرو بعد از آماده‌شدن integration' : 'Inventory and reservation after the integration is ready',
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => PharmacyPhase2Page(locale: locale))),
            ),
            const SizedBox(height: 10),
            Card(color: PhenoColors.sageSoft, child: ListTile(
              leading: const CircleAvatar(backgroundColor: PhenoColors.ivory, child: Icon(Icons.shield_outlined, color: PhenoColors.burgundy)),
              title: Text(s.isFa ? 'حریم خصوصی و امنیت' : 'Privacy & Security', style: const TextStyle(fontWeight: FontWeight.w700)),
              subtitle: Text(s.isFa ? 'رضایت، Sync و اصول حفاظت از داده' : 'Consent, sync, and data-protection foundations'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => PrivacyPage(locale: locale))),
            )),
            const FounderSignature(),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (index) {
          if (index == 1) {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => MedicationsPage(locale: locale, repository: _medicationRepository)));
          } else if (index == 2) {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => SchedulePage(locale: locale, medicationRepository: _medicationRepository, eventRepository: _doseEventRepository)));
          } else if (index == 3) {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => CabinetPage(locale: locale, repository: _medicationRepository)));
          } else if (index == 4) {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => ProfilePage(locale: locale, authService: _authService)));
          }
        },
        destinations: [
          NavigationDestination(icon: const Icon(Icons.home_outlined), label: s.isFa ? 'خانه' : 'Home'),
          NavigationDestination(icon: const Icon(Icons.medication_outlined), label: s.medications),
          NavigationDestination(icon: const Icon(Icons.calendar_month_outlined), label: s.schedule),
          NavigationDestination(icon: const Icon(Icons.inventory_2_outlined), label: s.cabinet),
          NavigationDestination(icon: const Icon(Icons.person_outline), label: s.profile),
        ]),
    );
  }
}

class _HomeAction extends StatelessWidget {
  const _HomeAction({required this.icon, required this.title, required this.subtitle, required this.onTap});

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      leading: CircleAvatar(
        backgroundColor: PhenoColors.sageSoft,
        child: Icon(icon, color: PhenoColors.burgundy),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Padding(padding: const EdgeInsets.only(top: 4), child: Text(subtitle)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    ),
  );
}

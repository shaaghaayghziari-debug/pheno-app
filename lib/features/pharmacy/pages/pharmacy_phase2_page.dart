import 'package:flutter/material.dart';
import '../../../core/theme/pheno_theme.dart';
import '../../../core/widgets/founder_signature.dart';

class PharmacyPhase2Page extends StatelessWidget {
  const PharmacyPhase2Page({super.key, required this.locale});
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    final fa = locale.languageCode == 'fa';
    return Scaffold(
      appBar: AppBar(title: Text(fa ? 'یافتن داروخانه' : 'Find a Pharmacy')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          Card(
            color: PhenoColors.sageSoft,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Icon(Icons.storefront_outlined, color: PhenoColors.burgundy, size: 32),
                const SizedBox(height: 12),
                Text(
                  fa ? 'مرحله ۲ PHENO' : 'PHENO Phase 2',
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
                ),
                const SizedBox(height: 8),
                Text(
                  fa
                      ? 'جست‌وجوی داروخانه، بررسی موجودی و رزرو/تهیه دارو در این مرحله به سرویس‌های واقعی داروخانه‌ها متصل خواهد شد.'
                      : 'Pharmacy search, inventory availability, and reservation will connect to real pharmacy services in Phase 2.',
                  style: const TextStyle(height: 1.5),
                ),
              ]),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(children: [
              ListTile(leading: const Icon(Icons.location_on_outlined), title: Text(fa ? 'یافتن داروخانه نزدیک' : 'Nearby pharmacies'), subtitle: Text(fa ? 'پس از اتصال سرویس مکان و شبکه داروخانه‌ها' : 'After location and pharmacy-network integration')),
              const Divider(height: 1),
              ListTile(leading: const Icon(Icons.inventory_2_outlined), title: Text(fa ? 'بررسی موجودی' : 'Availability check'), subtitle: Text(fa ? 'فقط بر اساس داده واقعی و به‌روز داروخانه' : 'Only from current pharmacy inventory data')),
              const Divider(height: 1),
              ListTile(leading: const Icon(Icons.event_available_outlined), title: Text(fa ? 'رزرو / تهیه مجدد' : 'Reserve / Refill'), subtitle: Text(fa ? 'بدون تغییر نسخه یا تصمیم درمانی' : 'Without changing a prescription or treatment decision')),
            ]),
          ),
          const SizedBox(height: 12),
          Text(
            fa ? 'این صفحه عمداً ادعای موجودی یا رزرو واقعی ندارد تا زمانی که اتصال رسمی فعال شود.' : 'This page intentionally makes no claim about live inventory or reservations until an official integration is active.',
            style: const TextStyle(color: PhenoColors.warmGray, height: 1.45),
          ),
          const FounderSignature(compact: true),
        ],
      ),
    );
  }
}

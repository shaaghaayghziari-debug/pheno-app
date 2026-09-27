import 'package:flutter/material.dart';
import '../../../core/widgets/founder_signature.dart';
import '../../../core/theme/pheno_theme.dart';

class PrivacyPage extends StatelessWidget {
  final Locale locale;
  const PrivacyPage({super.key, required this.locale});

  @override
  Widget build(BuildContext context) {
    final fa = locale.languageCode == 'fa';
    final sections = fa
        ? <(String, String)>[
            ('حریم خصوصی', 'PHENO اطلاعات دارویی را فقط برای قابلیت‌هایی که کاربر فعال می‌کند پردازش می‌کند و معماری آن برای کمینه‌سازی داده طراحی شده است.'),
            ('رضایت و کنترل کاربر', 'رضایت برای قابلیت‌هایی مانند همگام‌سازی ابری باید قابل مشاهده، قابل تغییر و مستقل از رضایت‌های دیگر باشد.'),
            ('امنیت حساب', 'توکن‌ها و اسرار حساب در production باید در فضای امن سیستم‌عامل نگهداری شوند؛ این نسخه قرارداد Secure Storage را فراهم می‌کند.'),
            ('همگام‌سازی', 'تغییرات ابتدا می‌توانند در صف محلی قرار بگیرند. اختلاف داده نباید با حدس‌زدن یا تغییر خودکار اطلاعات درمانی حل شود.'),
            ('اصل ایمنی بالینی', 'AI کمک می‌کند بفهمی، برنامه‌ریزی کنی و هشدار بگیری؛ اما تصمیم درمانی را خودش نمی‌گیرد.'),
          ]
        : <(String, String)>[
            ('Privacy', 'PHENO is designed to process medication information only for user-enabled features, with data minimization as a core architectural principle.'),
            ('Consent & control', 'Consent for features such as cloud sync should be visible, revocable, and independent from other consents.'),
            ('Account security', 'Production secrets and session tokens must use platform secure storage; this version provides the Secure Storage contract.'),
            ('Sync', 'Changes may first enter a local queue. Conflicts must never be resolved by guessing or silently changing treatment information.'),
            ('Clinical safety principle', 'AI helps users understand, organize, and warn; it does not make treatment decisions.'),
          ];
    return Scaffold(
      appBar: AppBar(title: Text(fa ? 'حریم خصوصی و امنیت' : 'Privacy & Security')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ...sections.map((section) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(section.$1, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: PhenoColors.burgundy)),
              const SizedBox(height: 8),
              Text(section.$2, style: const TextStyle(height: 1.5)),
            ]))),
          )),
          const FounderSignature(compact: true),
        ],
      ),
    );
  }
}

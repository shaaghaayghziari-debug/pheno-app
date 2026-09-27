import 'package:flutter/material.dart';
import '../../../core/localization/app_strings.dart';
import '../../security/models/security_models.dart';
import '../../security/services/auth_service.dart';
import '../../../core/widgets/founder_signature.dart';

class ProfilePage extends StatefulWidget {
  final Locale locale;
  final AuthService authService;

  const ProfilePage({super.key, required this.locale, required this.authService});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  PhenoUser? _user;

  @override
  void initState() {
    super.initState();
    widget.authService.currentUser().then((user) {
      if (mounted) setState(() => _user = user);
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings(widget.locale);
    return Scaffold(
      appBar: AppBar(title: Text(s.profile)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          CircleAvatar(radius: 34, child: Text((_user?.displayName ?? _user?.email ?? 'P').substring(0, 1).toUpperCase())),
          const SizedBox(height: 12),
          Center(child: Text(_user?.displayName ?? (s.isFa ? 'کاربر PHENO' : 'PHENO user'), style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700))),
          const SizedBox(height: 4),
          if (_user?.email != null) Center(child: Text(_user!.email!, style: Theme.of(context).textTheme.bodySmall)),
          const SizedBox(height: 24),
          Card(child: Column(children: [
            ListTile(leading: const Icon(Icons.lock_outline), title: Text(s.isFa ? 'امنیت حساب' : 'Account security'), subtitle: Text(s.isFa ? 'نشست و ذخیره‌سازی امن در معماری PHENO' : 'Session and secure-storage architecture')),
            const Divider(height: 1),
            ListTile(leading: const Icon(Icons.cloud_outlined), title: Text(s.isFa ? 'همگام‌سازی' : 'Cloud sync'), subtitle: Text(s.isFa ? 'وضعیت Sync در یک لایه مستقل مدیریت می‌شود' : 'Sync is managed through an independent service layer')),
          ])),
          const SizedBox(height: 10),
          const FounderSignature(),
        ],
      ),
    );
  }
}

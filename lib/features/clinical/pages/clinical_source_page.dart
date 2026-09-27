import 'package:flutter/material.dart';
import '../../../core/theme/pheno_theme.dart';
import '../models/clinical_knowledge.dart';
import '../../../core/widgets/founder_signature.dart';

class ClinicalSourcePage extends StatelessWidget {
  final bool isFa;
  const ClinicalSourcePage({super.key, required this.isFa});
  @override
  Widget build(BuildContext context) {
    const source = ClinicalSource(title: 'FDA / authoritative labeling', reference: 'Drug labeling and interaction information', type: ClinicalSourceType.label);
    return Scaffold(
      appBar: AppBar(title: Text(isFa ? 'منابع اطلاعات دارویی' : 'Clinical Sources')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(source.title, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: PhenoColors.burgundy)),
          const SizedBox(height: 10),
          Text(isFa ? 'اطلاعات ایمنی و تداخل باید از منابع دارویی معتبر تغذیه شوند.' : 'Safety and interaction data should be supplied by authoritative drug-information sources.'),
          const SizedBox(height: 16), Text(source.reference),
          const SizedBox(height: 20),
          Text(isFa ? 'PHENO برای فهم و هشدار کمک می‌کند؛ تصمیم درمانی را خودش نمی‌گیرد.' : 'PHENO helps explain and warn; it does not make treatment decisions.'),
          const FounderSignature(compact: true),
        ]))),
      ),
    );
  }
}

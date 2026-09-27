import 'package:flutter/material.dart';
import '../theme/pheno_theme.dart';

class FounderSignature extends StatelessWidget {
  const FounderSignature({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: compact ? 8 : 18),
      child: Center(
        child: Column(
          children: [
            Text(
              'PHENO',
              style: TextStyle(
                color: PhenoColors.burgundy,
                fontSize: compact ? 11 : 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'شقایق زیاری',
              textDirection: TextDirection.rtl,
              style: TextStyle(
                color: PhenoColors.charcoal,
                fontSize: compact ? 13 : 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Creator',
              style: TextStyle(
                color: PhenoColors.warmGray,
                fontSize: compact ? 9 : 10,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

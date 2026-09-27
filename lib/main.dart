import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme/pheno_theme.dart';
import 'features/home/home_page.dart';

void main() {
  runApp(const PhenoApp());
}

class PhenoApp extends StatefulWidget {
  const PhenoApp({super.key});

  @override
  State<PhenoApp> createState() => _PhenoAppState();
}

class _PhenoAppState extends State<PhenoApp> {
  Locale _locale = const Locale('fa');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PHENO',
      theme: PhenoTheme.light(),
      locale: _locale,
      supportedLocales: const [Locale('fa'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Directionality(
        textDirection: _locale.languageCode == 'fa' ? TextDirection.rtl : TextDirection.ltr,
        child: HomePage(
          locale: _locale,
          onLocaleChanged: (locale) => setState(() => _locale = locale),
        ),
      ),
    );
  }
}

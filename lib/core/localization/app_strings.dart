import 'package:flutter/widgets.dart';

class AppStrings {
  final Locale locale;
  const AppStrings(this.locale);

  bool get isFa => locale.languageCode == 'fa';

  String get appName => 'PHENO';
  String get tagline => isFa ? 'ساده. ایمن. همیشه.' : 'Simple. Safe. Always.';
  String get greeting => isFa ? 'صبح بخیر' : 'Good morning';
  String get todayMedications => isFa ? 'داروهای امروز' : "Today's Medications";
  String get nextDose => isFa ? 'دوز بعدی' : 'Next dose';
  String get viewSchedule => isFa ? 'مشاهده برنامه کامل' : 'View full schedule';
  String get medications => isFa ? 'داروها' : 'Medications';
  String get schedule => isFa ? 'برنامه' : 'Schedule';
  String get cabinet => isFa ? 'کابینت' : 'Cabinet';
  String get profile => isFa ? 'پروفایل' : 'Profile';
  String get taken => isFa ? 'مصرف شده' : 'taken';
  String get afterBreakfast => isFa ? 'بعد از صبحانه' : 'After breakfast';
  String get afterLunch => isFa ? 'بعد از ناهار' : 'After lunch';
  String get beforeSleep => isFa ? 'قبل از خواب' : 'Before sleep';
  String get markAsTaken => isFa ? 'مصرف کردم' : 'Mark as taken';
  String get smartSchedule => isFa ? 'برنامه هوشمند مصرف' : 'Smart medication schedule';
  String get scheduleDescription => isFa ? 'بر اساس دستور ثبت‌شده، زمان‌های مصرف را یک‌جا ببینید.' : 'See scheduled doses in one place, based on the recorded prescription.';
}

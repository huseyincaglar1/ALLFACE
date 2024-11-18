import 'package:flutter/material.dart';

class LanguageProvider with ChangeNotifier {
  Locale _locale = const Locale('tr'); // Default locale

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (!['en', 'tr'].contains(locale.languageCode)) return;
    _locale = locale;
    notifyListeners();
  }
}

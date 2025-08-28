import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/logger.dart';
import '../generated/l10n.dart';

class LocaleProvider with ChangeNotifier {
  static const String _localeKey = 'app_locale';
  Locale _locale = const Locale('de'); // Varsayılan Almanca

  Locale get locale => _locale;

  static const List<Locale> supportedLocales = [
    Locale('de'), // Almanca
    Locale('tr'), // Türkçe
    Locale('en'), // İngilizce
  ];

  static const Map<String, String> localeNames = {
    'de': 'Deutsch',
    'tr': 'Türkçe',
    'en': 'English',
  };

  LocaleProvider() {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final localeCode = prefs.getString(_localeKey) ?? 'de';
      _locale = Locale(localeCode);
      notifyListeners();
      logger.i('Locale loaded: $_locale');
    } catch (e) {
      logger.e('Locale load error: $e');
    }
  }

  Future<void> setLocale(Locale newLocale) async {
    if (!supportedLocales.contains(newLocale)) return;
    
    try {
      // Önce S.load ile uygulama dilini güncelle
      await S.load(newLocale);
      
      // Sonra locale'i değiştir
      _locale = newLocale;
      
      // Tercihi kaydet
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localeKey, newLocale.languageCode);
      
      logger.i('Locale changed to: $newLocale');
      logger.i('Locale resources reloaded');
      
      // Değişiklikleri bildir
      notifyListeners();
    } catch (e) {
      logger.e('Locale save error: $e');
    }
  }

  String getLocaleName(String languageCode) {
    return localeNames[languageCode] ?? languageCode;
  }
}

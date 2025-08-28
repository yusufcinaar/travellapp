// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

typedef MessageIfAbsent = String Function(String messageStr, List<dynamic> args);

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of(context, S);
  }

  String get appTitle => Intl.message('Seyahatname', name: 'appTitle');
  String get loginTitle => Intl.message('Giriş Yap', name: 'loginTitle');
  String get loginSubtitle => Intl.message('Google hesabınızla giriş yapın', name: 'loginSubtitle');
  String get signInWithGoogle => Intl.message('Google ile Giriş Yap', name: 'signInWithGoogle');
  String get homeTitle => Intl.message('Seyahatler', name: 'homeTitle');
  String get profileTitle => Intl.message('Profil', name: 'profileTitle');
  String get favoritesTitle => Intl.message('Favoriler', name: 'favoritesTitle');
  String get filterTitle => Intl.message('Filtrele', name: 'filterTitle');
  String get allCountries => Intl.message('Tüm Ülkeler', name: 'allCountries');
  String get allRegions => Intl.message('Tüm Bölgeler', name: 'allRegions');
  String get allCategories => Intl.message('Tüm Kategoriler', name: 'allCategories');
  String get germany => Intl.message('Almanya', name: 'germany');
  String get austria => Intl.message('Avusturya', name: 'austria');
  String get switzerland => Intl.message('İsviçre', name: 'switzerland');
  String get culture => Intl.message('Kültür', name: 'culture');
  String get nature => Intl.message('Doğa', name: 'nature');
  String get festival => Intl.message('Festival', name: 'festival');
  String get adventure => Intl.message('Macera', name: 'adventure');
  String get food => Intl.message('Yemek', name: 'food');
  String get addToFavorites => Intl.message('Favorilere Ekle', name: 'addToFavorites');
  String get removeFromFavorites => Intl.message('Favorilerden Çıkar', name: 'removeFromFavorites');
  String get startDate => Intl.message('Başlangıç Tarihi', name: 'startDate');
  String get endDate => Intl.message('Bitiş Tarihi', name: 'endDate');
  String get description => Intl.message('Açıklama', name: 'description');
  String get locationInfo => Intl.message('Konum Bilgisi', name: 'locationInfo');
  String get dateInfo => Intl.message('Tarih Bilgisi', name: 'dateInfo');
  String get duration => Intl.message('Süre', name: 'duration');
  String get days => Intl.message('gün', name: 'days');
  String get noFavorites => Intl.message('Henüz favori seyahatiniz bulunmuyor', name: 'noFavorites');
  String get fullName => Intl.message('Ad Soyad', name: 'fullName');
  String get accountCreated => Intl.message('Hesap Oluşturulma', name: 'accountCreated');
  String get lastLogin => Intl.message('Son Giriş', name: 'lastLogin');
  String get signOut => Intl.message('Çıkış Yap', name: 'signOut');
  String get listView => Intl.message('Liste Görünümü', name: 'listView');
  String get gridView => Intl.message('Izgara Görünümü', name: 'gridView');
  String get noTripsFound => Intl.message('Seyahat bulunamadı', name: 'noTripsFound');
  String get loading => Intl.message('Yükleniyor...', name: 'loading');
  String get error => Intl.message('Hata', name: 'error');
  String get retry => Intl.message('Tekrar Dene', name: 'retry');
  String get appLanguage => Intl.message('Uygulama Dili', name: 'appLanguage');
  String get clearFilters => Intl.message('Filtreleri Temizle', name: 'clearFilters');
  String get loginTab => Intl.message('Giriş Yap', name: 'loginTab');
  String get registerTab => Intl.message('Kayıt Ol', name: 'registerTab');
  String get appTagline => Intl.message('Seyahatlerini kolayca\nplanla, keşfet ve paylaş', name: 'appTagline');
  String get emailHint => Intl.message('E-posta adresiniz', name: 'emailHint');
  String get passwordHint => Intl.message('Şifreniz', name: 'passwordHint');
  String get passwordCreateHint => Intl.message('Şifre oluşturun', name: 'passwordCreateHint');
  String get pleaseWait => Intl.message('Lütfen bekleyin...', name: 'pleaseWait');
  String get emailValidationEmpty => Intl.message('Lütfen e-posta adresinizi girin', name: 'emailValidationEmpty');
  String get emailValidationInvalid => Intl.message('Geçerli bir e-posta adresi girin', name: 'emailValidationInvalid');
  String get passwordValidationEmpty => Intl.message('Lütfen şifrenizi girin', name: 'passwordValidationEmpty');
  String get passwordValidationLength => Intl.message('Şifre en az 6 karakter olmalıdır', name: 'passwordValidationLength');
  String get createPasswordValidationEmpty => Intl.message('Lütfen şifre oluşturun', name: 'createPasswordValidationEmpty');
  String get googleSignInError => Intl.message('Google ile giriş yaparken bir hata oluştu', name: 'googleSignInError');
  String get email => Intl.message('E-posta', name: 'email');
  String get share => Intl.message('Paylaş', name: 'share');
  String get googleSignInFailedSha => Intl.message('Google Sign-In başarısız oldu. Firebase Console\'da SHA-1 anahtarı eklenmiş olmalı.', name: 'googleSignInFailedSha');
  String get userInfoUnavailable => Intl.message('Kullanıcı bilgisi alınamadı', name: 'userInfoUnavailable');
  String get googleSignInErrorPrefix => Intl.message('Google Sign-In hatası', name: 'googleSignInErrorPrefix');
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'tr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}

Future<bool> initializeMessages(String localeName) async {
  return true;
}

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('tr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In de, this message translates to:
  /// **'Seyahatname'**
  String get appTitle;

  /// No description provided for @loginTitle.
  ///
  /// In de, this message translates to:
  /// **'Anmelden'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Melden Sie sich mit Ihrem Google-Konto an'**
  String get loginSubtitle;

  /// No description provided for @signInWithGoogle.
  ///
  /// In de, this message translates to:
  /// **'Mit Google anmelden'**
  String get signInWithGoogle;

  /// No description provided for @homeTitle.
  ///
  /// In de, this message translates to:
  /// **'Reisen'**
  String get homeTitle;

  /// No description provided for @profileTitle.
  ///
  /// In de, this message translates to:
  /// **'Profil'**
  String get profileTitle;

  /// No description provided for @favoritesTitle.
  ///
  /// In de, this message translates to:
  /// **'Favoriten'**
  String get favoritesTitle;

  /// No description provided for @appLanguage.
  ///
  /// In de, this message translates to:
  /// **'App-Sprache'**
  String get appLanguage;

  /// No description provided for @filterTitle.
  ///
  /// In de, this message translates to:
  /// **'Filter'**
  String get filterTitle;

  /// No description provided for @allCountries.
  ///
  /// In de, this message translates to:
  /// **'Alle Länder'**
  String get allCountries;

  /// No description provided for @allRegions.
  ///
  /// In de, this message translates to:
  /// **'Alle Regionen'**
  String get allRegions;

  /// No description provided for @allCategories.
  ///
  /// In de, this message translates to:
  /// **'Alle Kategorien'**
  String get allCategories;

  /// No description provided for @locationInfo.
  ///
  /// In de, this message translates to:
  /// **'Standortinformationen'**
  String get locationInfo;

  /// No description provided for @dateInfo.
  ///
  /// In de, this message translates to:
  /// **'Datumsangaben'**
  String get dateInfo;

  /// No description provided for @duration.
  ///
  /// In de, this message translates to:
  /// **'Dauer'**
  String get duration;

  /// No description provided for @days.
  ///
  /// In de, this message translates to:
  /// **'Tage'**
  String get days;

  /// No description provided for @description.
  ///
  /// In de, this message translates to:
  /// **'Beschreibung'**
  String get description;

  /// No description provided for @noFavorites.
  ///
  /// In de, this message translates to:
  /// **'Sie haben noch keine Lieblingsreisen'**
  String get noFavorites;

  /// No description provided for @germany.
  ///
  /// In de, this message translates to:
  /// **'Deutschland'**
  String get germany;

  /// No description provided for @austria.
  ///
  /// In de, this message translates to:
  /// **'Österreich'**
  String get austria;

  /// No description provided for @switzerland.
  ///
  /// In de, this message translates to:
  /// **'Schweiz'**
  String get switzerland;

  /// No description provided for @culture.
  ///
  /// In de, this message translates to:
  /// **'Kultur'**
  String get culture;

  /// No description provided for @nature.
  ///
  /// In de, this message translates to:
  /// **'Natur'**
  String get nature;

  /// No description provided for @festival.
  ///
  /// In de, this message translates to:
  /// **'Festival'**
  String get festival;

  /// No description provided for @adventure.
  ///
  /// In de, this message translates to:
  /// **'Abenteuer'**
  String get adventure;

  /// No description provided for @food.
  ///
  /// In de, this message translates to:
  /// **'Essen'**
  String get food;

  /// No description provided for @addToFavorites.
  ///
  /// In de, this message translates to:
  /// **'Zu Favoriten hinzufügen'**
  String get addToFavorites;

  /// No description provided for @removeFromFavorites.
  ///
  /// In de, this message translates to:
  /// **'Aus Favoriten entfernen'**
  String get removeFromFavorites;

  /// No description provided for @startDate.
  ///
  /// In de, this message translates to:
  /// **'Startdatum'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In de, this message translates to:
  /// **'Enddatum'**
  String get endDate;

  /// No description provided for @fullName.
  ///
  /// In de, this message translates to:
  /// **'Vollständiger Name'**
  String get fullName;

  /// No description provided for @accountCreated.
  ///
  /// In de, this message translates to:
  /// **'Konto erstellt'**
  String get accountCreated;

  /// No description provided for @lastLogin.
  ///
  /// In de, this message translates to:
  /// **'Letzte Anmeldung'**
  String get lastLogin;

  /// No description provided for @signOut.
  ///
  /// In de, this message translates to:
  /// **'Abmelden'**
  String get signOut;

  /// No description provided for @listView.
  ///
  /// In de, this message translates to:
  /// **'Listenansicht'**
  String get listView;

  /// No description provided for @gridView.
  ///
  /// In de, this message translates to:
  /// **'Rasteransicht'**
  String get gridView;

  /// No description provided for @noTripsFound.
  ///
  /// In de, this message translates to:
  /// **'Keine Reisen gefunden'**
  String get noTripsFound;

  /// No description provided for @loading.
  ///
  /// In de, this message translates to:
  /// **'Wird geladen...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In de, this message translates to:
  /// **'Fehler'**
  String get error;

  /// No description provided for @retry.
  ///
  /// In de, this message translates to:
  /// **'Wiederholen'**
  String get retry;

  /// No description provided for @clearFilters.
  ///
  /// In de, this message translates to:
  /// **'Filter löschen'**
  String get clearFilters;

  /// No description provided for @loginTab.
  ///
  /// In de, this message translates to:
  /// **'Anmelden'**
  String get loginTab;

  /// No description provided for @registerTab.
  ///
  /// In de, this message translates to:
  /// **'Registrieren'**
  String get registerTab;

  /// No description provided for @appTagline.
  ///
  /// In de, this message translates to:
  /// **'Plane, entdecke und teile\ndeine Reisen einfach'**
  String get appTagline;

  /// No description provided for @emailHint.
  ///
  /// In de, this message translates to:
  /// **'Deine E-Mail-Adresse'**
  String get emailHint;

  /// No description provided for @passwordHint.
  ///
  /// In de, this message translates to:
  /// **'Dein Passwort'**
  String get passwordHint;

  /// No description provided for @passwordCreateHint.
  ///
  /// In de, this message translates to:
  /// **'Passwort erstellen'**
  String get passwordCreateHint;

  /// No description provided for @pleaseWait.
  ///
  /// In de, this message translates to:
  /// **'Bitte warten...'**
  String get pleaseWait;

  /// No description provided for @emailValidationEmpty.
  ///
  /// In de, this message translates to:
  /// **'Bitte gib deine E-Mail-Adresse ein'**
  String get emailValidationEmpty;

  /// No description provided for @emailValidationInvalid.
  ///
  /// In de, this message translates to:
  /// **'Bitte gib eine gültige E-Mail-Adresse ein'**
  String get emailValidationInvalid;

  /// No description provided for @passwordValidationEmpty.
  ///
  /// In de, this message translates to:
  /// **'Bitte gib dein Passwort ein'**
  String get passwordValidationEmpty;

  /// No description provided for @passwordValidationLength.
  ///
  /// In de, this message translates to:
  /// **'Das Passwort muss mindestens 6 Zeichen lang sein'**
  String get passwordValidationLength;

  /// No description provided for @createPasswordValidationEmpty.
  ///
  /// In de, this message translates to:
  /// **'Bitte erstelle ein Passwort'**
  String get createPasswordValidationEmpty;

  /// No description provided for @googleSignInError.
  ///
  /// In de, this message translates to:
  /// **'Fehler bei der Anmeldung mit Google'**
  String get googleSignInError;

  /// No description provided for @email.
  ///
  /// In de, this message translates to:
  /// **'E-Mail'**
  String get email;

  /// No description provided for @share.
  ///
  /// In de, this message translates to:
  /// **'Teilen'**
  String get share;

  /// No description provided for @googleSignInFailedSha.
  ///
  /// In de, this message translates to:
  /// **'Google-Anmeldung fehlgeschlagen. Der SHA-1-Schlüssel muss in der Firebase Console hinzugefügt werden.'**
  String get googleSignInFailedSha;

  /// No description provided for @userInfoUnavailable.
  ///
  /// In de, this message translates to:
  /// **'Benutzerinformationen konnten nicht abgerufen werden'**
  String get userInfoUnavailable;

  /// No description provided for @googleSignInErrorPrefix.
  ///
  /// In de, this message translates to:
  /// **'Google-Anmeldefehler'**
  String get googleSignInErrorPrefix;

  /// No description provided for @registrationSuccessful.
  ///
  /// In de, this message translates to:
  /// **'Registrierung erfolgreich! Bitte melden Sie sich mit Ihrem neuen Konto an.'**
  String get registrationSuccessful;

  /// No description provided for @fullNameHint.
  ///
  /// In de, this message translates to:
  /// **'Ihr vollständiger Name'**
  String get fullNameHint;

  /// No description provided for @fullNameValidationEmpty.
  ///
  /// In de, this message translates to:
  /// **'Bitte geben Sie Ihren vollständigen Namen ein'**
  String get fullNameValidationEmpty;

  /// No description provided for @fullNameValidationLength.
  ///
  /// In de, this message translates to:
  /// **'Der Name muss mindestens 3 Zeichen lang sein'**
  String get fullNameValidationLength;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

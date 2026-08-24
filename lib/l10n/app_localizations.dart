import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_as.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_brx.dart';
import 'app_localizations_doi.dart';
import 'app_localizations_en.dart';
import 'app_localizations_gom.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_ks.dart';
import 'app_localizations_mai.dart';
import 'app_localizations_ml.dart';
import 'app_localizations_mni.dart';
import 'app_localizations_mr.dart';
import 'app_localizations_ne.dart';
import 'app_localizations_or.dart';
import 'app_localizations_pa.dart';
import 'app_localizations_sa.dart';
import 'app_localizations_sat.dart';
import 'app_localizations_sd.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';
import 'app_localizations_ur.dart';

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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('en'),
    Locale('as'),
    Locale('bn'),
    Locale('brx'),
    Locale('doi'),
    Locale('gom'),
    Locale('gu'),
    Locale('hi'),
    Locale('kn'),
    Locale('ks'),
    Locale('mai'),
    Locale('ml'),
    Locale('mni'),
    Locale('mr'),
    Locale('ne'),
    Locale('or'),
    Locale('pa'),
    Locale('sa'),
    Locale('sat'),
    Locale('sd'),
    Locale('ta'),
    Locale('te'),
    Locale('ur')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Nazar.Ai'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Protect your kid, peace of mind'**
  String get appTagline;

  /// No description provided for @roleSelectTitle.
  ///
  /// In en, this message translates to:
  /// **'Hey! Who are you?'**
  String get roleSelectTitle;

  /// No description provided for @roleParent.
  ///
  /// In en, this message translates to:
  /// **'Parent'**
  String get roleParent;

  /// No description provided for @roleParentDesc.
  ///
  /// In en, this message translates to:
  /// **'Monitor your little one from here'**
  String get roleParentDesc;

  /// No description provided for @roleChild.
  ///
  /// In en, this message translates to:
  /// **'Child'**
  String get roleChild;

  /// No description provided for @roleChildDesc.
  ///
  /// In en, this message translates to:
  /// **'Scan the QR from your parent\'s phone first'**
  String get roleChildDesc;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Sign Up Now'**
  String get register;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Your email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccount;

  /// No description provided for @haveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get haveAccount;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logout;

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Hi, Welcome!'**
  String get dashboardTitle;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE PROTECTION'**
  String get active;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'INACTIVE'**
  String get inactive;

  /// No description provided for @noDetection.
  ///
  /// In en, this message translates to:
  /// **'All clear!'**
  String get noDetection;

  /// No description provided for @noDetectionDesc.
  ///
  /// In en, this message translates to:
  /// **'No suspicious activity yet. Your little one is doing just fine'**
  String get noDetectionDesc;

  /// No description provided for @todayDetection.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayDetection;

  /// No description provided for @weekDetection.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get weekDetection;

  /// No description provided for @detectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Detection Details'**
  String get detectionTitle;

  /// No description provided for @confidence.
  ///
  /// In en, this message translates to:
  /// **'How confident is the AI?'**
  String get confidence;

  /// No description provided for @triggeredBy.
  ///
  /// In en, this message translates to:
  /// **'Triggered by'**
  String get triggeredBy;

  /// No description provided for @keywords.
  ///
  /// In en, this message translates to:
  /// **'Suspicious keywords'**
  String get keywords;

  /// No description provided for @markAsRead.
  ///
  /// In en, this message translates to:
  /// **'Okay, I\'ve read it'**
  String get markAsRead;

  /// No description provided for @ocr.
  ///
  /// In en, this message translates to:
  /// **'Read Text'**
  String get ocr;

  /// No description provided for @mobilenet.
  ///
  /// In en, this message translates to:
  /// **'Look at Image'**
  String get mobilenet;

  /// No description provided for @trustpositif.
  ///
  /// In en, this message translates to:
  /// **'Check URL'**
  String get trustpositif;

  /// No description provided for @combined.
  ///
  /// In en, this message translates to:
  /// **'Caught from everywhere'**
  String get combined;

  /// No description provided for @pairingTitle.
  ///
  /// In en, this message translates to:
  /// **'Connect Your Child\'s Phone'**
  String get pairingTitle;

  /// No description provided for @pairingDesc.
  ///
  /// In en, this message translates to:
  /// **'Ask your little one to scan this QR from their phone!'**
  String get pairingDesc;

  /// No description provided for @scanQR.
  ///
  /// In en, this message translates to:
  /// **'Scan the QR first!'**
  String get scanQR;

  /// No description provided for @scanQRDesc.
  ///
  /// In en, this message translates to:
  /// **'Point the camera at the QR Code on your parent\'s phone'**
  String get scanQRDesc;

  /// No description provided for @pairingSuccess.
  ///
  /// In en, this message translates to:
  /// **'Yay, the phone is connected!'**
  String get pairingSuccess;

  /// No description provided for @addChild.
  ///
  /// In en, this message translates to:
  /// **'Add Child'**
  String get addChild;

  /// No description provided for @childName.
  ///
  /// In en, this message translates to:
  /// **'Child\'s name'**
  String get childName;

  /// No description provided for @childAge.
  ///
  /// In en, this message translates to:
  /// **'How old are they?'**
  String get childAge;

  /// No description provided for @saveChild.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveChild;

  /// No description provided for @educationTitle.
  ///
  /// In en, this message translates to:
  /// **'Hey, sweetie. Wait a moment'**
  String get educationTitle;

  /// No description provided for @educationBody.
  ///
  /// In en, this message translates to:
  /// **'The content that just appeared isn\'t good for you. It\'s called online gambling, and it can really ruin your future.\n\nGo tell your mom or dad about it. They\'ll definitely understand, and they always love you.'**
  String get educationBody;

  /// No description provided for @educationButton.
  ///
  /// In en, this message translates to:
  /// **'I Understand'**
  String get educationButton;

  /// No description provided for @serviceActive.
  ///
  /// In en, this message translates to:
  /// **'Nazar.Ai is watching over you'**
  String get serviceActive;

  /// No description provided for @serviceInactive.
  ///
  /// In en, this message translates to:
  /// **'Hey, Nazar.Ai is turned off'**
  String get serviceInactive;

  /// No description provided for @serviceInactiveDesc.
  ///
  /// In en, this message translates to:
  /// **'Your child\'s phone isn\'t protected. Check it now!'**
  String get serviceInactiveDesc;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @notificationDesc.
  ///
  /// In en, this message translates to:
  /// **'Get notified right away if something looks suspicious'**
  String get notificationDesc;

  /// No description provided for @connectedDevices.
  ///
  /// In en, this message translates to:
  /// **'Connected Phones'**
  String get connectedDevices;

  /// No description provided for @errorGeneral.
  ///
  /// In en, this message translates to:
  /// **'Oops, something went wrong. Try again?'**
  String get errorGeneral;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Looks like the internet is acting up'**
  String get errorNetwork;

  /// No description provided for @errorLogin.
  ///
  /// In en, this message translates to:
  /// **'Your email or password is wrong'**
  String get errorLogin;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Hey, welcome\nback!'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Log in so you can monitor your little one'**
  String get loginSubtitle;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Let\'s create\na new account!'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign up now, it\'s free!'**
  String get registerSubtitle;

  /// No description provided for @registerLink.
  ///
  /// In en, this message translates to:
  /// **'Sign up now'**
  String get registerLink;

  /// No description provided for @loginLink.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get loginLink;

  /// No description provided for @validEmpty.
  ///
  /// In en, this message translates to:
  /// **'This can\'t be empty'**
  String get validEmpty;

  /// No description provided for @validEmailFormat.
  ///
  /// In en, this message translates to:
  /// **'That email format isn\'t quite right'**
  String get validEmailFormat;

  /// No description provided for @validPassword.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get validPassword;

  /// No description provided for @validName.
  ///
  /// In en, this message translates to:
  /// **'Name can\'t be empty'**
  String get validName;

  /// No description provided for @validEmail.
  ///
  /// In en, this message translates to:
  /// **'Email can\'t be empty'**
  String get validEmail;

  /// No description provided for @validPasswordEmpty.
  ///
  /// In en, this message translates to:
  /// **'Password can\'t be empty'**
  String get validPasswordEmpty;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred language'**
  String get languageDesc;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @madeWith.
  ///
  /// In en, this message translates to:
  /// **'Made with love'**
  String get madeWith;

  /// No description provided for @protectingKids.
  ///
  /// In en, this message translates to:
  /// **'Protecting kids from online gambling'**
  String get protectingKids;

  /// No description provided for @editAccountDetails.
  ///
  /// In en, this message translates to:
  /// **'Edit Account Details'**
  String get editAccountDetails;

  /// No description provided for @addNewChild.
  ///
  /// In en, this message translates to:
  /// **'Add New Child'**
  String get addNewChild;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @chooseProfilePhoto.
  ///
  /// In en, this message translates to:
  /// **'Choose Profile Photo'**
  String get chooseProfilePhoto;

  /// No description provided for @profilePhotoUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile photo updated successfully!'**
  String get profilePhotoUpdated;

  /// No description provided for @failedToUploadPhoto.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload photo'**
  String get failedToUploadPhoto;

  /// No description provided for @readyToLogout.
  ///
  /// In en, this message translates to:
  /// **'Ready to log out?'**
  String get readyToLogout;

  /// No description provided for @logoutMessage.
  ///
  /// In en, this message translates to:
  /// **'You\'ll be logged out of your Nazar.Ai account.\nYour children\'s data stays safe!'**
  String get logoutMessage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @yearsOld.
  ///
  /// In en, this message translates to:
  /// **'years old'**
  String get yearsOld;

  /// No description provided for @activeStatus.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get activeStatus;

  /// No description provided for @noChildrenConnected.
  ///
  /// In en, this message translates to:
  /// **'No children connected yet'**
  String get noChildrenConnected;

  /// No description provided for @addChildFirst.
  ///
  /// In en, this message translates to:
  /// **'Add a child first!'**
  String get addChildFirst;

  /// No description provided for @unlink.
  ///
  /// In en, this message translates to:
  /// **'Unlink'**
  String get unlink;

  /// No description provided for @unlinked.
  ///
  /// In en, this message translates to:
  /// **'phone has been unlinked'**
  String get unlinked;

  /// No description provided for @failedToUnlink.
  ///
  /// In en, this message translates to:
  /// **'Failed to unlink, try again?'**
  String get failedToUnlink;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0'**
  String get version;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'as',
        'bn',
        'brx',
        'doi',
        'en',
        'gom',
        'gu',
        'hi',
        'kn',
        'ks',
        'mai',
        'ml',
        'mni',
        'mr',
        'ne',
        'or',
        'pa',
        'sa',
        'sat',
        'sd',
        'ta',
        'te',
        'ur'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'as':
      return AppLocalizationsAs();
    case 'bn':
      return AppLocalizationsBn();
    case 'brx':
      return AppLocalizationsBrx();
    case 'doi':
      return AppLocalizationsDoi();
    case 'en':
      return AppLocalizationsEn();
    case 'gom':
      return AppLocalizationsGom();
    case 'gu':
      return AppLocalizationsGu();
    case 'hi':
      return AppLocalizationsHi();
    case 'kn':
      return AppLocalizationsKn();
    case 'ks':
      return AppLocalizationsKs();
    case 'mai':
      return AppLocalizationsMai();
    case 'ml':
      return AppLocalizationsMl();
    case 'mni':
      return AppLocalizationsMni();
    case 'mr':
      return AppLocalizationsMr();
    case 'ne':
      return AppLocalizationsNe();
    case 'or':
      return AppLocalizationsOr();
    case 'pa':
      return AppLocalizationsPa();
    case 'sa':
      return AppLocalizationsSa();
    case 'sat':
      return AppLocalizationsSat();
    case 'sd':
      return AppLocalizationsSd();
    case 'ta':
      return AppLocalizationsTa();
    case 'te':
      return AppLocalizationsTe();
    case 'ur':
      return AppLocalizationsUr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}

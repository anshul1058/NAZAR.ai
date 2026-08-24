// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kannada (`kn`).
class AppLocalizationsKn extends AppLocalizations {
  AppLocalizationsKn([String locale = 'kn']) : super(locale);

  @override
  String get appName => 'Nazar.Ai';

  @override
  String get appTagline => 'ನಿಮ್ಮ ಮಗುವನ್ನು ರಕ್ಷಿಸಿ, ಮಾನಸಿಕ ಶಾಂತಿ ಪಡೆಯಿರಿ';

  @override
  String get roleSelectTitle => 'ನಮಸ್ಕಾರ! ನೀವು ಯಾರು?';

  @override
  String get roleParent => 'ಪೋಷಕರು';

  @override
  String get roleParentDesc => 'ಇಲ್ಲಿ ನಿಮ್ಮ ಚಿಕ್ಕ ಮಗುವನ್ನು ಮೇಲ್ವಿಚಾರಣೆ ಮಾಡಿ';

  @override
  String get roleChild => 'ಮಗು';

  @override
  String get roleChildDesc =>
      'ಮೊದಲು ನಿಮ್ಮ ಪೋಷಕರ ಫೋನ್‌ನಲ್ಲಿರುವ QR ಅನ್ನು ಸ್ಕ್ಯಾನ್ ಮಾಡಿ';

  @override
  String get login => 'ಲಾಗಿನ್';

  @override
  String get register => 'ಈಗಲೇ ಸೈನ್ ಅಪ್ ಮಾಡಿ';

  @override
  String get email => 'ನಿಮ್ಮ ಇಮೇಲ್';

  @override
  String get password => 'ಪಾಸ್‌ವರ್ಡ್';

  @override
  String get fullName => 'ಪೂರ್ಣ ಹೆಸರು';

  @override
  String get noAccount => 'ಖಾತೆ ಇಲ್ಲವೇ?';

  @override
  String get haveAccount => 'ಈಗಾಗಲೇ ಖಾತೆ ಇದೆಯೇ?';

  @override
  String get logout => 'ಲಾಗ್ ಔಟ್';

  @override
  String get dashboardTitle => 'ನಮಸ್ಕಾರ, ಸ್ವಾಗತ!';

  @override
  String get active => 'ಸಕ್ರಿಯ ರಕ್ಷಣೆ';

  @override
  String get inactive => 'ನಿಷ್ಕ್ರಿಯ';

  @override
  String get noDetection => 'ಎಲ್ಲವೂ ಸರಿಯಾಗಿದೆ!';

  @override
  String get noDetectionDesc =>
      'ಇದುವರೆಗೂ ಅನುಮಾನಾಸ್ಪದ ಚಟುವಟಿಕೆಗಳು ಯಾವುದೂ ಇಲ್ಲ. ನಿಮ್ಮ ಚಿಕ್ಕ ಮಗು ಚೆನ್ನಾಗಿದೆ';

  @override
  String get todayDetection => 'ಇಂದು';

  @override
  String get weekDetection => 'ಈ ವಾರ';

  @override
  String get detectionTitle => 'ಪತ್ತೆ ವಿವರಗಳು';

  @override
  String get confidence => 'AI ಎಷ್ಟು ವಿಶ್ವಾಸಾರ್ಹವಾಗಿದೆ?';

  @override
  String get triggeredBy => 'ಪ್ರೇರೇಪಿಸಿದ್ದು';

  @override
  String get keywords => 'ಅನುಮಾನಾಸ್ಪದ ಪದಗಳು';

  @override
  String get markAsRead => 'ಸರಿ, ನಾನು ಓದಿದ್ದೇನೆ';

  @override
  String get ocr => 'ಪಠ್ಯವನ್ನು ಓದಿ';

  @override
  String get mobilenet => 'ಚಿತ್ರವನ್ನು ನೋಡಿ';

  @override
  String get trustpositif => 'URL ಅನ್ನು ಪರಿಶೀಲಿಸಿ';

  @override
  String get combined => 'ಎಲ್ಲಾ ಕಡೆ ಹಿಡಿಯಲ್ಪಟ್ಟಿದೆ';

  @override
  String get pairingTitle => 'ನಿಮ್ಮ ಮಗುವಿನ ಫೋನ್ ಅನ್ನು ಸಂಪರ್ಕಿಸಿ';

  @override
  String get pairingDesc =>
      'ನಿಮ್ಮ ಚಿಕ್ಕ ಮಗುವಿಗೆ ಅವರ ಫೋನ್‌ನಿಂದ ಈ QR ಅನ್ನು ಸ್ಕ್ಯಾನ್ ಮಾಡಲು ಹೇಳಿ!';

  @override
  String get scanQR => 'ಮೊದಲು QR ಅನ್ನು ಸ್ಕ್ಯಾನ್ ಮಾಡಿ!';

  @override
  String get scanQRDesc =>
      'ನಿಮ್ಮ ಪೋಷಕರ ಫೋನ್‌ನಲ್ಲಿರುವ QR ಕೋಡ್ ಕಡೆಗೆ ಕ್ಯಾಮರಾ ತಿರುಗಿಸಿ';

  @override
  String get pairingSuccess => 'ಯಾ, ಫೋನ್ ಸಂಪರ್ಕಗೊಂಡಿದೆ!';

  @override
  String get addChild => 'ಮಗುವನ್ನು ಸೇರಿಸಿ';

  @override
  String get childName => 'ಮಗುವಿನ ಹೆಸರು';

  @override
  String get childAge => 'ವಯಸು ಎಷ್ಟು?';

  @override
  String get saveChild => 'ಉಳಿಸಿ';

  @override
  String get educationTitle => 'ಚಿಕ್ಕಾ, ಒಂದು ನಿಮಿಷ ತಾಳಿರಿ';

  @override
  String get educationBody =>
      'ಈಗ ಕಾಣಿಸಿಕೊಂಡ ವಿಷಯವು ನಿಮಗೆ ಒಳ್ಳೆಯದಲ್ಲ. ಇದನ್ನು ಆನ್‌ಲೈನ್ ಜೂಜಾಟ ಎಂದು ಕರೆಯುತ್ತಾರೆ, ಇದು ನಿಮ್ಮ ಭವಿಷ್ಯವನ್ನು ನಿಜವಾಗಿಯೂ ಹಾಳುಮಾಡಬಹುದು.\n\nಇದನ್ನು ನಿಮ್ಮ ಅಮ್ಮ ಅಥವಾ ಅಪ್ಪಾಜಿಗೆ ಹೇಳಿ. ಅವರು ಖಂಡಿತವಾಗಿಯೂ ಅರ್ಥಮಾಡಿಕೊಳ್ಳುತ್ತಾರೆ, ಮತ್ತು ಅವರು ಯಾವಾಗಲೂ ನಿಮ್ಮನ್ನು ಪ್ರೀತಿಸುತ್ತಾರೆ.';

  @override
  String get educationButton => 'ನನಗೆ ಅರ್ಥವಾಯಿತು';

  @override
  String get serviceActive => 'Nazar.Ai ನಿಮ್ಮನ್ನು ಕಾಯುತ್ತಿದೆ';

  @override
  String get serviceInactive => 'ನಜಾರ್.ಎಐ ಆಫ್ ಮಾಡಲಾಗಿದೆ';

  @override
  String get serviceInactiveDesc =>
      'ನಿಮ್ಮ ಮಗುವಿನ ಫೋನ್ ರಕ್ಷಿಸಲಾಗಿಲ್ಲ. ಈಗಲೇ ಪರಿಶೀಲಿಸಿ!';

  @override
  String get settingsTitle => 'ಸೆಟ್ಟಿಂಗ್‌ಗಳು';

  @override
  String get notifications => 'ಅಧಿಸೂಚನೆಗಳು';

  @override
  String get notificationDesc =>
      'ಅನುಮಾನಾಸ್ಪದವಾಗಿ ಏನಾದರೂ ಕಂಡುಬಂದರೆ ತಕ್ಷಣ ಅಧಿಸೂಚನೆ ಪಡೆಯಿರಿ';

  @override
  String get connectedDevices => 'ಸಂಪರ್ಕಿಸಲಾದ ಫೋನ್‌ಗಳು';

  @override
  String get errorGeneral => 'ಅಯ್ಯೋ, ಏನೋ ತಪ್ಪು ನಡೆದಿದೆ. ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಬೇಕೇ?';

  @override
  String get errorNetwork => 'ಇಂಟರ್ನೆಟ್ ಸರಿಯಾಗಿ ಕೆಲಸ ಮಾಡುತ್ತಿಲ್ಲ ಅನಿಸುತ್ತಿದೆ';

  @override
  String get errorLogin => 'ನಿಮ್ಮ ಇಮೇಲ್ ಅಥವಾ ಪಾಸ್‌ವರ್ಡ್ ತಪ್ಪಾಗಿದೆ';

  @override
  String get loginTitle => 'ನಮಸ್ಕಾರ, ಮತ್ತೆ\nಸ್ವಾಗತ!';

  @override
  String get loginSubtitle =>
      'ನಿಮ್ಮ ಚಿಕ್ಕ ಮಗುವನ್ನು ಮೇಲ್ವಿಚಾರಣೆ ಮಾಡಲು ಲಾಗಿನ್ ಆಗಿ';

  @override
  String get registerTitle => 'ಹೊಸ ಖಾತೆಯನ್ನು\nಸೃಷ್ಟಿಸೋಣ!';

  @override
  String get registerSubtitle => 'ಈಗಲೇ ಸೈನ್ ಅಪ್ ಮಾಡಿ, ಇದು ಉಚಿತ!';

  @override
  String get registerLink => 'ಈಗಲೇ ಸೈನ್ ಅಪ್ ಮಾಡಿ';

  @override
  String get loginLink => 'ಲಾಗಿನ್';

  @override
  String get validEmpty => 'ಇದು ಖಾಲಿ ಇರಲು ಸಾಧ್ಯವಿಲ್ಲ';

  @override
  String get validEmailFormat => 'ಇಮೇಲ್ ಫಾರ್ಮ್ಯಾಟ್ ಸರಿಯಾಗಿಲ್ಲ';

  @override
  String get validPassword => 'ಪಾಸ್‌ವರ್ಡ್ ಕನಿಷ್ಠ 6 ಅಕ್ಷರಗಳನ್ನು ಹೊಂದಿರಬೇಕು';

  @override
  String get validName => 'ಹೆಸರು ಖಾಲಿ ಇರಲು ಸಾಧ್ಯವಿಲ್ಲ';

  @override
  String get validEmail => 'ಇಮೇಲ್ ಖಾಲಿ ಇರಲು ಸಾಧ್ಯವಿಲ್ಲ';

  @override
  String get validPasswordEmpty => 'ಪಾಸ್‌ವರ್ಡ್ ಖಾಲಿ ಇರಲು ಸಾಧ್ಯವಿಲ್ಲ';

  @override
  String get language => 'ಭಾಷೆ';

  @override
  String get languageDesc => 'ನಿಮ್ಮ ಆದ್ಯತೆಯ ಭಾಷೆಯನ್ನು ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get about => 'ಕುರಿತು';

  @override
  String get madeWith => 'ಪ್ರೀತಿಯಿಂದ ಮಾಡಲಾಗಿದೆ';

  @override
  String get protectingKids => 'ಆನ್‌ಲೈನ್ ಜೂಜಾಟದಿಂದ ಮಕ್ಕಳನ್ನು ರಕ್ಷಿಸುತ್ತಿದೆ';

  @override
  String get editAccountDetails => 'ಖಾತೆ ವಿವರಗಳನ್ನು ಸಂಪಾದಿಸಿ';

  @override
  String get addNewChild => 'ಹೊಸ ಮಗುವನ್ನು ಸೇರಿಸಿ';

  @override
  String get camera => 'ಕ್ಯಾಮರಾ';

  @override
  String get gallery => 'ಗ್ಯಾಲರಿ';

  @override
  String get chooseProfilePhoto => 'ಪ್ರೊಫೈಲ್ ಫೋಟೋ ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get profilePhotoUpdated => 'ಪ್ರೊಫೈಲ್ ಫೋಟೋ ಯಶಸ್ವಿಯಾಗಿ ನವೀಕರಿಸಲಾಗಿದೆ!';

  @override
  String get failedToUploadPhoto => 'ಫೋಟೋ ಅಪ್‌ಲೋಡ್ ಮಾಡಲು ವಿಫಲವಾಗಿದೆ';

  @override
  String get readyToLogout => 'ಲಾಗ್ ಔಟ್ ಮಾಡಲು ಸಿದ್ಧರಾಗಿದ್ದೀರಾ?';

  @override
  String get logoutMessage =>
      'ನಿಮ್ಮ Nazar.Ai ಖಾತೆಯಿಂದ ಲಾಗ್ ಔಟ್ ಆಗುವಿರಿ.\nನಿಮ್ಮ ಮಕ್ಕಳ ಡೇಟಾ ಸುರಕ್ಷಿತವಾಗಿರುತ್ತದೆ!';

  @override
  String get cancel => 'ರದ್ದುಮಾಡಿ';

  @override
  String get yearsOld => 'ವರ್ಷಗಳು';

  @override
  String get activeStatus => 'ಸಕ್ರಿಯ';

  @override
  String get noChildrenConnected => 'ಇನ್ನೂ ಮಕ್ಕಳನ್ನು ಸಂಪರ್ಕಿಸಲಾಗಿಲ್ಲ';

  @override
  String get addChildFirst => 'ಮೊದಲು ಮಗುವನ್ನು ಸೇರಿಸಿ!';

  @override
  String get unlink => 'ಲಿಂಕ್ ತೆಗೆದುಹಾಕಿ';

  @override
  String get unlinked => 'ಫೋನ್ ಲಿಂಕ್ ತೆಗೆದುಹಾಕಲಾಗಿದೆ';

  @override
  String get failedToUnlink =>
      'ಲಿಂಕ್ ತೆಗೆದುಹಾಕಲು ವಿಫಲವಾಗಿದೆ, ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಬೇಕೇ?';

  @override
  String get version => 'ಆವೃತ್ತಿ 1.0.0';
}

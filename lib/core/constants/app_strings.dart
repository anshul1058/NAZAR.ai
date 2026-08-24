class AppStrings {
  // App
  static const String appName = 'Nazar.Ai';
  static const String appTagline = 'Protect your kid, peace of mind';

  // Role Select
  static const String roleSelectTitle = 'Hey! Who are you?';
  static const String roleParent = 'Parent';
  static const String roleParentDesc = 'Monitor your little one from here';
  static const String roleChild = 'Child';
  static const String roleChildDesc =
      "Scan the QR from your parent's phone first";

  // Auth
  static const String login = 'Log In';
  static const String register = 'Sign Up Now';
  static const String email = 'Your email';
  static const String password = 'Password';
  static const String fullName = 'Full Name';
  static const String noAccount = "Don't have an account?";
  static const String haveAccount = 'Already have an account?';
  static const String logout = 'Log Out';

  // Dashboard
  static const String dashboardTitle = 'Hi, Welcome!';
  static const String active = 'ACTIVE PROTECTION';
  static const String inactive = 'INACTIVE';
  static const String noDetection = 'All clear!';
  static const String noDetectionDesc = 'No suspicious activity yet. '
      'Your little one is doing just fine';
  static const String todayDetection = 'Today';
  static const String weekDetection = 'This Week';

  // Detection
  static const String detectionTitle = 'Detection Details';
  static const String confidence = 'How confident is the AI?';
  static const String triggeredBy = 'Triggered by';
  static const String keywords = 'Suspicious keywords';
  static const String markAsRead = "Okay, I've read it";

  // Triggered by
  static const String ocr = 'Read Text';
  static const String mobilenet = 'Look at Image';
  static const String trustpositif = 'Check URL';
  static const String combined = 'Caught from everywhere';

  // Pairing
  static const String pairingTitle = "Connect Your Child's Phone";
  static const String pairingDesc = 'Ask your little one to scan this QR '
      'from their phone!';
  static const String scanQR = 'Scan the QR first!';
  static const String scanQRDesc = "Point the camera at the QR Code "
      "on your parent's phone";
  static const String pairingSuccess = 'Yay, the phone is connected!';

  // Add Child
  static const String addChild = 'Add Child';
  static const String childName = "Child's name";
  static const String childAge = 'How old are they?';
  static const String saveChild = 'Save';

  // Education screen
  static const String educationTitle = 'Hey, sweetie. Wait a moment';
  static const String educationBody =
      "The content that just appeared isn't good for you. "
      "It's called online gambling, and it can really ruin your future. "
      '\n\nGo tell your mom or dad about it. '
      "They'll definitely understand, and they always love you.";
  static const String educationButton = 'I Understand';

  // Service status
  static const String serviceActive = 'Nazar.Ai is watching over you';
  static const String serviceInactive = 'Hey, Nazar.Ai is turned off';
  static const String serviceInactiveDesc =
      "Your child's phone isn't protected. Check it now!";

  // Settings
  static const String settingsTitle = 'Settings';
  static const String notification = 'Notifications';
  static const String notificationDesc =
      'Get notified right away if something looks suspicious';
  static const String connectedDevices = 'Connected Phones';

  // Error
  static const String errorGeneral = 'Oops, something went wrong. Try again?';
  static const String errorNetwork = 'Looks like the internet is acting up';
  static const String errorLogin = 'Your email or password is wrong';

  // Auth — add below the existing ones
  static const String loginTitle = 'Hey, welcome\nback! 👋';
  static const String loginSubtitle = 'Log in so you can monitor your little one';
  static const String registerTitle = "Let's create\na new account! 🎉";
  static const String registerSubtitle = "Sign up now, it's free!";
  static const String registerLink = 'Sign up now';
  static const String loginLink = 'Log In';

  // Validation
  static const String validEmpty = "This can't be empty";
  static const String validEmailFormat = "That email format isn't quite right";
  static const String validPassword = 'Password must be at least 6 characters';
  static const String validName = "Name can't be empty";
  static const String validEmail = "Email can't be empty";
  static const String validPasswordEmpty = "Password can't be empty";
}
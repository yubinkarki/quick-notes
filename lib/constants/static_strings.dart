class AppStrings {
  static const String no = 'No';
  static const String empty = '';
  static const String yes = 'Yes';
  static const String ok = 'Okay';
  static const String add = 'Add';
  static const String login = 'Login';
  static const String error = 'Error';
  static const String email = 'Email';
  static const String great = 'Great';
  static const String delete = 'Delete';
  static const String update = 'Update';
  static const String cancel = 'Cancel';
  static const String logout = 'Logout';
  static const String sharing = 'Sharing';
  static const String success = 'Success';
  static const String nothing = 'Nothing';
  static const String delaying = 'Delaying';
  static const String appName = 'Quick Notes';
  static const String yourNotes = 'Your Notes';
  static const String noUser = 'User not found';
  static const String goToLogin = 'Go to Login';
  static const String addNewNote = 'Add new note';
  static const String sharingNote = 'Sharing Note';
  static const String backToLogin = 'Back to Login';
  static const String enterEmail = 'Enter your email';
  static const String goToRegister = 'Go to Register';
  static const String passwordReset = 'Reset Password';
  static const String verifyEmail = 'Verify your email';
  static const String authError = 'Authentication error';
  static const String emptyValidation = 'Please provide';
  static const String forgotPassword = 'Forgot password';
  static const String addNote = 'Write your note here...';
  static const String noteAdded = 'Note added successfully';
  static const String enterPassword = 'Enter your password';
  static const String incorrectPassword = 'Incorrect password';
  static const String addError = 'Please write something to add';
  static const String noNotes = 'There are no notes right now...';
  static const String emailValidation = 'Please enter a valid email';
  static const String updateError = 'Please write something to update';
  static const String sendEmailVerification = 'Send email verification';
  static const String sendPasswordResetLink = 'Send password reset link';
  static const String invalidNoteShare = 'You can not share an empty note';
  static const String logoutConfirmation = 'Are you sure you want to log out?';
  static const String deleteConfirmation = 'Are you sure you want to delete this item?';

  static const String resendEmailVerification =
      "If you haven't received a verification email yet, press the button below.";
  static const String emailVerificationConfirmation =
      "We've sent you an email verification. Please open it to verify your account.";
  static const String passwordResetSubtitle =
      'We have sent you a password reset link. Please check your email for more information.';
  static const String resetPasswordMessage = 'Enter your email to get a link to reset your password.';
  static const String emailRegEx =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  static String notesCount(int count) {
    return 'All Notes - $count';
  }
}

class AppExceptions {
  static const String invalidAuthException = 'Invalid Auth Exception';
  static const String userNotFoundException = 'User Not Found Exception';
  static const String somethingWentWrongException = 'Something went wrong';
}

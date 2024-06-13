import "package:okaychata/imports/first_party_imports.dart" show AppStrings;

class Validator {
  static String? emptyValidation(String? inputValue, String? inputName) {
    if (inputValue == null || inputValue.trim().toLowerCase().isEmpty) {
      return "${AppStrings.emptyValidation} ${inputName?.trim().toLowerCase() ?? 'input'}";
    }

    return null;
  }

  static String? emailValidation(String inputValue) {
    if (inputValue.isNotEmpty) {
      final bool isEmailValid = RegExp(AppStrings.emailRegEx).hasMatch(inputValue);

      if (!isEmailValid) {
        return AppStrings.emailValidation;
      }
    }

    return null;
  }
}

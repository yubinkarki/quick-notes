import 'package:okaychata/constants/static_strings.dart';

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

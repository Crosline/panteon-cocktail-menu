class Validator {
  static String? stringValidator(String? value) {
    if(value == null) return "Field cannot be empty.";

    if (value.isEmpty) return "Field cannot be empty.";

    return null;
  }
}
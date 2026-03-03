import 'package:ddd_setup/common/domain/errors.dart';
import 'package:ddd_setup/common/domain/value_object.dart';

class PhoneNumber extends ValueObject {
  @override
  final String value;
  const PhoneNumber._(this.value);

  static ValueObjectResult<PhoneNumber> create(String input) {
    const phoneRegex = r'^1[3456789]\d{9}$';
    if (RegExp(phoneRegex).hasMatch(input)) {
      return ValueObjectSuccess(PhoneNumber._(input));
    } else {
      return ValueObjectFailure(
        ValueFailure(message: "Invalid phone number "),
      );
    }
  }
}

class Password extends ValueObject {
  @override
  final String value;
  const Password._(this.value);

  static ValueObjectResult<Password> create(String input) {
    if (input.length >= 6) {
      return ValueObjectSuccess(Password._(input));
    } else {
      return ValueObjectFailure(
        ValueFailure(message: "Password must be at least 6 characters"),
      );
    }
  }
}

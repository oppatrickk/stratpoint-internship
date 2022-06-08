import 'package:dartz/dartz.dart';

import 'package:stratpoint_internship/domain/core/failures.dart';
import 'package:kt_dart/kt.dart';

// Validate Notes
Either<ValueFailure<String>, String> validateMaxStringLength(
  String? input,
  int maxLength,
) {
  if (input == null) {
    return left(ValueFailure<String>.notes(NotesValueFailure<String>.exceedingLength(failedValue: input, max: maxLength)));
  }

  if (input.length <= maxLength) {
    return right(input);
  } else {
    return left(ValueFailure<String>.notes(NotesValueFailure<String>.exceedingLength(failedValue: input, max: maxLength)));
  }
}

Either<ValueFailure<String>, String> validateStringNotEmpty(
  String? input,
) {
  if (input == null) {
    return left(ValueFailure<String>.notes(NotesValueFailure<String>.empty(failedValue: input)));
  }

  if (input.isNotEmpty) {
    return right(input);
  } else {
    return left(ValueFailure<String>.notes(NotesValueFailure<String>.empty(failedValue: input)));
  }
}

Either<ValueFailure<String>, String> validateSingleLine(
  String? input,
) {
  if (input == null) {
    return left(ValueFailure<String>.notes(NotesValueFailure<String>.multiLine(failedValue: input)));
  }

  if (!input.contains('\n')) {
    return right(input);
  } else {
    return left(ValueFailure<String>.notes(NotesValueFailure<String>.multiLine(failedValue: input)));
  }
}

Either<ValueFailure<KtList<T>>, KtList<T>> validateMaxListLength<T>(
  KtList<T>? input,
  int maxLength,
) {
  if (input == null) {
    return left(ValueFailure<KtList<T>>.notes(NotesValueFailure<KtList<T>>.listTooLong(failedValue: input, max: maxLength)));
  }

  if (input.size <= maxLength) {
    return right(input);
  } else {
    return left(ValueFailure<KtList<T>>.notes(NotesValueFailure<KtList<T>>.listTooLong(failedValue: input, max: maxLength)));
  }
}

// Validate Login Authentication
Either<ValueFailure<String>, String> validateEmailAddress(String? input) {
  const String emailRegex = r"""^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+""";

  if (input == null) {
    return left(ValueFailure<String>.auth(AuthValueFailure<String>.invalidEmail(failedValue: input)));
  }

  if (RegExp(emailRegex).hasMatch(input)) {
    return right(input);
  } else {
    return left(ValueFailure<String>.auth(AuthValueFailure<String>.invalidEmail(failedValue: input)));
  }
}

Either<ValueFailure<String>, String> validatePassword(String? input) {
  if (input == null) {
    return left(ValueFailure<String>.auth(AuthValueFailure<String>.shortPassword(failedValue: input)));
  }

  if (input.length >= 6) {
    return right(input);
  } else {
    return left(ValueFailure<String>.auth(AuthValueFailure<String>.shortPassword(failedValue: input)));
  }
}

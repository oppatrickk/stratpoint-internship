import 'package:dartz/dartz.dart';

import 'package:stratpoint_internship/domain/core/failures.dart';
import 'package:stratpoint_internship/domain/core/value_objects.dart';
import 'package:kt_dart/kt.dart';

// Validate Notes
Either<ValueFailure<String>, String> validateMaxStringLength(
  String? input,
  int maxLength,
) {
  if (input == null) {
    return left(ValueFailure.notes(NotesValueFailure.exceedingLength(failedValue: input, max: maxLength)));
  }

  if (input.length <= maxLength) {
    return right(input);
  } else {
    return left(ValueFailure.notes(NotesValueFailure.exceedingLength(failedValue: input, max: maxLength)));
  }
}

Either<ValueFailure<String>, String> validateStringNotEmpty(
  String? input,
) {
  if (input == null) {
    return left(ValueFailure.notes(NotesValueFailure.empty(failedValue: input)));
  }

  if (input.isNotEmpty) {
    return right(input);
  } else {
    return left(ValueFailure.notes(NotesValueFailure.empty(failedValue: input)));
  }
}

Either<ValueFailure<String>, String> validateSingleLine(
  String? input,
) {
  if (input == null) {
    return left(ValueFailure.notes(NotesValueFailure.multiLine(failedValue: input)));
  }

  if (!input.contains('\n')) {
    return right(input);
  } else {
    return left(ValueFailure.notes(NotesValueFailure.multiLine(failedValue: input)));
  }
}

Either<ValueFailure<KtList<T>>, KtList<T>> validateMaxListLength<T>(
  KtList<T>? input,
  int maxLength,
) {
  if (input == null) {
    return left(ValueFailure.notes(NotesValueFailure.listTooLong(failedValue: input, max: maxLength)));
  }

  if (input.size <= maxLength) {
    return right(input);
  } else {
    return left(ValueFailure.notes(NotesValueFailure.listTooLong(failedValue: input, max: maxLength)));
  }
}

// Validate Login Authentication
Either<ValueFailure<String>, String> validateEmailAddress(String? input) {
  const String emailRegex = r"""^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+""";

  if (input == null) {
    return left(ValueFailure.auth(AuthValueFailure.invalidEmail(failedValue: input)));
  }

  if (RegExp(emailRegex).hasMatch(input)) {
    return right(input);
  } else {
    return left(ValueFailure.auth(AuthValueFailure.invalidEmail(failedValue: input)));
  }
}

Either<ValueFailure<String>, String> validatePassword(String? input) {
  if (input == null) {
    return left(ValueFailure.auth(AuthValueFailure.shortPassword(failedValue: input)));
  }

  if (input.length >= 6) {
    return right(input);
  } else {
    return left(ValueFailure.auth(AuthValueFailure.shortPassword(failedValue: input)));
  }
}

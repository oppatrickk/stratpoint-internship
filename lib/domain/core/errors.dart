import 'package:stratpoint_internship/domain/core/failures.dart';

class NotAuthenticatedError extends Error {}

class UnexpectedValueError extends Error {
  UnexpectedValueError(this.valueFailure);
  final ValueFailure<dynamic> valueFailure;

  @override
  String toString() {
    const String explanation = 'Encountered a ValueFailure at an unrecoverable point. Terminating';
    return Error.safeToString('$explanation Failure was: $valueFailure');
  }
}

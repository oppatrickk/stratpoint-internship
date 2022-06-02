import 'package:stratpoint_internship/domain/core/failures.dart';

class UnexpectedValueError extends Error {
  UnexpectedValueError(this.valueFailure);
  final ValueFailure valueFailure;

  @override
  String toString() {
    const String explanation = 'Encountered a ValueFailure at an unrecoverable point. Terminating';
    return Error.safeToString('$explanation Failure was: $valueFailure');
  }
}

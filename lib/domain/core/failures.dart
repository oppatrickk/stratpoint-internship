import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

@freezed
abstract class ValueFailure<T> with _$ValueFailure<T> {
  const factory ValueFailure.invalidEmail({
    required String failedValue,
  }) = InvalidEmail<T>;

  const factory ValueFailure.shortPassword({
    required String failedValue,
  }) = ShortPassword<T>;
}

/*
void showingTheEmailAddressOrFailure() {
  final emailAddress = EmailAddress('fasda');

  String emailText = emailAddress.value.fold(
    (left) => 'Failure happened, more precisely: $left',
    (right) => right,
  );

  String emailText2 =
      emailAddress.value.getOrElse(() => 'Some Failure Happened');
}
*/
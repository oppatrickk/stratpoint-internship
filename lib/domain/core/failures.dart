import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

@freezed
class ValueFailure<T> with _$ValueFailure<T> {
  const factory ValueFailure.auth(AuthValueFailure<T> f) = _Auth<T>;
  const factory ValueFailure.notes(NotesValueFailure<T> f) = _Notes<T>;
}

@freezed
class AuthValueFailure<T> with _$AuthValueFailure<T> {
  const factory AuthValueFailure.invalidEmail({
    required T? failedValue,
  }) = InvalidEmail<T>;

  const factory AuthValueFailure.shortPassword({
    required T? failedValue,
  }) = ShortPassword<T>;
}

@freezed
class NotesValueFailure<T> with _$NotesValueFailure<T> {
  const factory NotesValueFailure.exceedingLength({
    required T? failedValue,
    required int? max,
  }) = ExceedingLength<T>;

  const factory NotesValueFailure.empty({
    required T? failedValue,
  }) = Empty<T>;

  const factory NotesValueFailure.multiLine({
    required T? failedValue,
  }) = MultiLine<T>;

  const factory NotesValueFailure.listTooLong({
    required T? failedValue,
    required int? max,
  }) = ListTooLong<T>;
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
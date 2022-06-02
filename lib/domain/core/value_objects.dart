import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:stratpoint_internship/domain/core/errors.dart';
import 'package:stratpoint_internship/domain/core/failures.dart';

@immutable
abstract class ValueObject<T> {
  const ValueObject();
  Either<ValueFailure<T>, T> get value;

  T getorCrash() {
    return value.fold((ValueFailure<T> f) => throw UnexpectedValueError(f), (r) => r);
  }

  bool isValid() => value.isRight();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ValueObject<T> && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Value(value: $value)';
}

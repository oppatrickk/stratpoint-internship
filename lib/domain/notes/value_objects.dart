import 'dart:ui';

import 'package:kt_dart/kt.dart';
import 'package:stratpoint_internship/domain/core/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:stratpoint_internship/domain/core/value_objects.dart';
import 'package:stratpoint_internship/domain/core/value_transformers.dart';
import 'package:stratpoint_internship/domain/core/value_validators.dart';

class NoteBody extends ValueObject<String> {
  factory NoteBody(String input) {
    assert(input != null);
    return NoteBody._(
      validateMaxStringLength(input, maxLength).flatMap(validateStringNotEmpty),
    );
  }
  const NoteBody._(this.value);

  @override
  final Either<ValueFailure<String>, String> value;

  static const int maxLength = 1000;
}

class TodoName extends ValueObject<String> {
  factory TodoName(String input) {
    assert(input != null);
    return TodoName._(
      validateMaxStringLength(input, maxLength).flatMap(validateStringNotEmpty).flatMap(validateSingleLine),
    );
  }
  const TodoName._(this.value);

  @override
  final Either<ValueFailure<String>, String> value;

  static const int maxLength = 30;
}

class NoteColor extends ValueObject<Color> {
  const NoteColor._(this.value);

  factory NoteColor(Color input) {
    assert(input != null);
    return NoteColor._(
      right(makeColorOpaque(input)),
    );
  }
  static const List<Color> predefinedColors = [
    Color(0xfffafafa), // canvas
    Color(0xfffa8072), // salmon
    Color(0xfffedc56), // mustard
    Color(0xffd0f0c0), // tea
    Color(0xfffca3b7), // flamingo
    Color(0xff997950), // tortilla
    Color(0xfffffdd0), // cream
  ];

  @override
  final Either<ValueFailure<Color>, Color> value;
}

class List3<T> extends ValueObject<KtList<T>> {
  factory List3(KtList<T> input) {
    assert(input != null);
    return List3._(
      validateMaxListLength(input, maxLength),
    );
  }
  const List3._(this.value);

  @override
  final Either<ValueFailure<KtList<T>>, KtList<T>> value;

  static const int maxLength = 3;

  int get length {
    return value.getOrElse(() => emptyList()).size;
  }

  bool get isFull {
    if (length == maxLength) {
      return true;
    } else {
      return false;
    }
  }
}

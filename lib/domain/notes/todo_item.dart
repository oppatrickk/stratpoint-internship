import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:stratpoint_internship/domain/core/failures.dart';
import 'package:stratpoint_internship/domain/core/value_objects.dart';
import 'package:stratpoint_internship/domain/notes/value_objects.dart';

part 'todo_item.freezed.dart';

@freezed
class TodoItem implements _$TodoItem {
  const TodoItem._();

  const factory TodoItem({
    required UniqueId id,
    required TodoName name,
    required bool done,
  }) = _TodoItem;

  factory TodoItem.empty() => TodoItem(
        id: UniqueId(),
        name: TodoName(''),
        done: false,
      );

  Option<ValueFailure<dynamic>> get failureOption {
    return name.value.fold((ValueFailure<String> f) => some(f), (_) => none());
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

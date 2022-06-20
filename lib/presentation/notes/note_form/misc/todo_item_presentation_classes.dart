import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kt_dart/kt.dart';
import 'package:stratpoint_internship/domain/core/value_objects.dart';
import 'package:stratpoint_internship/domain/notes/todo_item.dart';
import 'package:stratpoint_internship/domain/notes/value_objects.dart';

part 'todo_item_presentation_classes.freezed.dart';

class FormTodos extends ValueNotifier<KtList<TodoItemPrimitive>> {
  FormTodos() : super(emptyList<TodoItemPrimitive>());
}

@freezed
class TodoItemPrimitive implements _$TodoItemPrimitive {
  const TodoItemPrimitive._();

  const factory TodoItemPrimitive({
    required UniqueId id,
    required String name,
    required bool done,
  }) = _TodoItemPrimitive;

  factory TodoItemPrimitive.empty() => TodoItemPrimitive(
        id: UniqueId(),
        name: '',
        done: false,
      );

  factory TodoItemPrimitive.fromDomain(TodoItem todoItem) {
    return TodoItemPrimitive(
      id: todoItem.id,
      name: todoItem.name.getorCrash(),
      done: todoItem.done,
    );
  }

  TodoItem toDomain() {
    return TodoItem(
      id: id,
      name: TodoName(name),
      done: done,
    );
  }

  @override
  // TODO: implement copyWith
  $TodoItemPrimitiveCopyWith<TodoItemPrimitive> get copyWith => throw UnimplementedError();

  @override
  // TODO: implement done
  bool get done => throw UnimplementedError();

  @override
  // TODO: implement id
  UniqueId get id => throw UnimplementedError();

  @override
  // TODO: implement name
  String get name => throw UnimplementedError();
}

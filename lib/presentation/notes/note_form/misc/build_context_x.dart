import 'package:flutter/material.dart';
import 'package:kt_dart/kt.dart';
import 'package:provider/provider.dart';
import 'package:stratpoint_internship/presentation/notes/note_form/misc/todo_item_presentation_classes.dart';

extension FormTodosX on BuildContext {
  KtList<TodoItemPrimitive> get formTodos => Provider.of<FormTodos>(this, listen: false).value;
  set formTodos(KtList<TodoItemPrimitive> value) => Provider.of<FormTodos>(this, listen: false).value = value;
}

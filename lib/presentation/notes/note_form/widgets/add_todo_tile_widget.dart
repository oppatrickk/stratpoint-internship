import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kt_dart/collection.dart';

import 'package:stratpoint_internship/application/notes/note_form/note_form_bloc.dart';
import 'package:stratpoint_internship/domain/core/failures.dart';
import 'package:stratpoint_internship/domain/notes/todo_item.dart';
import 'package:stratpoint_internship/presentation/notes/note_form/misc/todo_item_presentation_classes.dart';
import 'package:stratpoint_internship/presentation/notes/note_form/misc/build_context_x.dart';

class AddTodoTile extends StatelessWidget {
  const AddTodoTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NoteFormBloc, NoteFormState>(
      listenWhen: (NoteFormState previous, NoteFormState current) => previous.isEditing != current.isEditing,
      listener: (BuildContext context, NoteFormState state) {
        context.formTodos = state.note.todos.value.fold((ValueFailure<KtList<TodoItem>> f) => listOf<TodoItemPrimitive>(),
            (KtList<TodoItem> todoItemList) => todoItemList.map((_) => TodoItemPrimitive.fromDomain(_)));
      },
      buildWhen: (NoteFormState previous, NoteFormState current) => previous.note.todos.isFull != current.note.todos.isFull,
      builder: (BuildContext context, NoteFormState state) {
        return ListTile(
          enabled: !state.note.todos.isFull,
          title: const Text('Add a Todo'),
          leading: const Padding(
            padding: EdgeInsets.all(12.0),
            child: Icon(Icons.add),
          ),
          onTap: () {
            context.formTodos = context.formTodos.plusElement(TodoItemPrimitive.empty());
            context.read<NoteFormBloc>().add(
                  NoteFormEvent.todosChanged(
                    context.formTodos,
                  ),
                );
          },
        );
      },
    );
  }
}

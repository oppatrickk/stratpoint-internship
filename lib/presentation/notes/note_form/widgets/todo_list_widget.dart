import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kt_dart/kt.dart';
import 'package:provider/provider.dart';
import 'package:stratpoint_internship/application/notes/note_form/note_form_bloc.dart';
import 'package:stratpoint_internship/presentation/notes/note_form/misc/todo_item_presentation_classes.dart';
import 'package:stratpoint_internship/presentation/notes/note_form/misc/build_context_x.dart';

class TodoList extends StatelessWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<NoteFormBloc, NoteFormState>(
      listenWhen: (NoteFormState previous, NoteFormState current) => previous.note.todos.isFull != current.note.todos.isFull,
      listener: (BuildContext context, NoteFormState state) {
        if (state.note.todos.isFull) {
          FlushbarHelper.createAction(
            message: 'Want longer lists? Activate Premium 🤩',
            button: TextButton(
              onPressed: () {},
              child: const Text(
                'BUY NOW!',
                style: TextStyle(color: Colors.yellow),
              ),
            ),
            duration: const Duration(seconds: 5),
          ).show(context);
        }
      },
      child: Consumer<FormTodos>(
        builder: (BuildContext context, FormTodos formTodos, Widget? child) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: formTodos.value.size,
            itemBuilder: (BuildContext context, int index) {
              return TodoTile(index: index);
            },
          );
        },
      ),
    );
  }
}

class TodoTile extends HookWidget {
  const TodoTile({Key? key, required this.index}) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    final TodoItemPrimitive todo = context.formTodos.getOrElse(index, (_) => TodoItemPrimitive.empty());

    return ListTile(
      leading: Checkbox(
        value: todo.done,
        onChanged: (bool? value) {
          context.formTodos = context.formTodos.map(
            (TodoItemPrimitive listTodo) => listTodo == todo ? todo.copyWith(done: value!) : listTodo,
          );
          context.read<NoteFormBloc>().add(NoteFormEvent.todosChanged(context.formTodos));
        },
      ),
    );
  }
}

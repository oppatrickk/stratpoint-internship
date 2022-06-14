import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:kt_dart/kt.dart';
import 'package:provider/provider.dart';

import 'package:stratpoint_internship/application/notes/note_form/note_form_bloc.dart';
import 'package:stratpoint_internship/domain/core/failures.dart';
import 'package:stratpoint_internship/domain/core/value_objects.dart';
import 'package:stratpoint_internship/domain/notes/todo_item.dart';
import 'package:stratpoint_internship/domain/notes/value_objects.dart';
import 'package:stratpoint_internship/presentation/notes/note_form/misc/build_context_x.dart';
import 'package:stratpoint_internship/presentation/notes/note_form/misc/todo_item_presentation_classes.dart';

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
          return ImplicitlyAnimatedReorderableList<TodoItemPrimitive>(
            shrinkWrap: true,
            removeDuration: const Duration(seconds: 0),
            items: formTodos.value.asList(),
            areItemsTheSame: (TodoItemPrimitive oldItem, TodoItemPrimitive newItem) => oldItem.id == newItem.id,
            onReorderFinished: (TodoItemPrimitive item, int from, int to, List<TodoItemPrimitive> newItems) {
              context.formTodos = newItems.toImmutableList();
              context.read<NoteFormBloc>().add(NoteFormEvent.todosChanged(context.formTodos));
            },
            itemBuilder: (BuildContext context, Animation<double> itemAnimation, TodoItemPrimitive item, int index) {
              return Reorderable(
                key: ValueKey<UniqueId>(item.id),
                builder: (BuildContext context, Animation<double> dragAnimation, bool inDrag) {
                  return ScaleTransition(
                    scale: Tween<double>(begin: 1, end: 0.95).animate(dragAnimation),
                    child: TodoTile(
                      index: index,
                      elevation: dragAnimation.value * 4,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class TodoTile extends HookWidget {
  const TodoTile({Key? key, required this.index, double? elevation})
      : elevation = elevation ?? 0,
        super(key: key);

  final int index;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    final TodoItemPrimitive todo = context.formTodos.getOrElse(index, (_) => TodoItemPrimitive.empty());
    final TextEditingController textEditingController = useTextEditingController(text: todo.name);

    return Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.20,
        children: <Widget>[
          SlidableAction(
            label: 'Delete',
            backgroundColor: Colors.red,
            icon: Icons.delete,
            onPressed: (BuildContext context) {
              context.formTodos = context.formTodos.minusElement(todo);
              context.read<NoteFormBloc>().add(NoteFormEvent.todosChanged(context.formTodos));
            },
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Material(
          elevation: elevation,
          animationDuration: const Duration(milliseconds: 50),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              leading: Checkbox(
                value: todo.done,
                onChanged: (bool? value) {
                  context.formTodos = context.formTodos.map(
                    (TodoItemPrimitive listTodo) => listTodo == todo ? todo.copyWith(done: value!) : listTodo,
                  );
                  context.read<NoteFormBloc>().add(NoteFormEvent.todosChanged(context.formTodos));
                },
              ),
              trailing: const Handle(
                child: Icon(Icons.list),
              ),
              title: TextFormField(
                controller: textEditingController,
                decoration: const InputDecoration(
                  hintText: 'Todo',
                  counterText: '',
                  border: InputBorder.none,
                ),
                maxLength: TodoName.maxLength,
                onChanged: (String value) {
                  context.formTodos = context.formTodos.map(
                    (TodoItemPrimitive listTodo) => listTodo == todo ? todo.copyWith(name: value) : listTodo,
                  );
                  context.read<NoteFormBloc>().add(NoteFormEvent.todosChanged(context.formTodos));
                },
                validator: (_) {
                  // ! Error not implemented correctly
                  return context.read<NoteFormBloc>().state.note.todos.value.fold(
                        (ValueFailure<KtList<TodoItem>> f) => null,
                        (KtList<TodoItem> todoList) => todoList[index].name.value.fold(
                              (ValueFailure<String> f) => f.maybeMap(
                                notes: (value) => value.f.maybeMap(
                                  empty: (_) => 'Cannot be Empty',
                                  exceedingLength: (_) => 'Too long',
                                  multiLine: (_) => 'Has to be in a single line',
                                  orElse: () => null,
                                ),
                                orElse: () => null,
                              ),
                              (_) => null,
                            ),
                      );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

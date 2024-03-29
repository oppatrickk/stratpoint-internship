import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stratpoint_internship/application/notes/note_actor/note_actor_bloc.dart';
import 'package:stratpoint_internship/domain/notes/note.dart';
import 'package:kt_dart/kt.dart';
import 'package:stratpoint_internship/domain/notes/todo_item.dart';
import 'package:stratpoint_internship/presentation/routes/router.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({Key? key, required this.note}) : super(key: key);

  final Note note;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: note.color.getorCrash(),
      child: InkWell(
        onTap: () {
          AutoRouter.of(context).push(
            NoteFormPageRoute(editedNote: note),
          );
        },
        onLongPress: () {
          final NoteActorBloc noteActorBloc = context.read<NoteActorBloc>();
          _showDeletionDialog(context, noteActorBloc);
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                note.body.getorCrash(),
                style: const TextStyle(fontSize: 18),
              ),
              if (note.todos.length > 0) ...<Widget>[
                const SizedBox(
                  height: 4,
                ),
                Wrap(
                  spacing: 8,
                  children: <Widget>[
                    ...note.todos
                        .getorCrash()
                        .map(
                          (TodoItem todo) => TodoDisplay(
                            todo: todo,
                          ),
                        )
                        .iter,
                  ],
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  void _showDeletionDialog(BuildContext context, NoteActorBloc noteActorBloc) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Selected note:'),
          content: Text(
            note.body.getorCrash(),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                noteActorBloc.add(NoteActorEvent.deleted(note));
                Navigator.pop(context);
              },
              child: const Text(
                'DELETE',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}

class TodoDisplay extends StatelessWidget {
  const TodoDisplay({Key? key, required this.todo}) : super(key: key);

  final TodoItem todo;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (todo.done)
          Icon(
            Icons.check_box,
            color: Theme.of(context).colorScheme.secondary,
          ),
        if (!todo.done)
          Icon(
            Icons.check_box_outline_blank,
            color: Theme.of(context).disabledColor,
          ),
        Text(todo.name.getorCrash()),
      ],
    );
  }
}

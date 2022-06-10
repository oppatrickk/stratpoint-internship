import 'package:flutter/material.dart';
import 'package:stratpoint_internship/domain/notes/note.dart';

class ErrorNoteCard extends StatelessWidget {
  const ErrorNoteCard({Key? key, required this.note}) : super(key: key);

  final Note note;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).errorColor,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            Text(
              'INVALID NOTE!',
              style: Theme.of(context).primaryTextTheme.bodyText2?.copyWith(fontSize: 24),
            ),
            Text(
              'Please contact support',
              style: Theme.of(context).primaryTextTheme.bodyText2?.copyWith(fontSize: 12),
            ),
            const SizedBox(height: 12.0),
            Text(
              'Details for nerds:',
              style: Theme.of(context).primaryTextTheme.bodyText2,
            ),
            Text(
              note.failureOption.fold(() => '', (f) => f.toString()),
              style: Theme.of(context).primaryTextTheme.bodyText2,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stratpoint_internship/application/notes/note_watcher/note_watcher_bloc.dart';
import 'package:stratpoint_internship/domain/notes/note.dart';
import 'package:stratpoint_internship/presentation/notes/notes_overview/widgets/critical_failure_display_widget.dart';
import 'package:stratpoint_internship/presentation/notes/notes_overview/widgets/error_note_card_widget.dart';
import 'package:stratpoint_internship/presentation/notes/notes_overview/widgets/note_card_widget.dart';

class NotesOverviewBody extends StatelessWidget {
  const NotesOverviewBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteWatcherBloc, NoteWatcherState>(
      builder: (BuildContext context, NoteWatcherState state) {
        return state.map(
          initial: (_) => Container(),
          loadInProgress: (_) => const Center(
            child: CircularProgressIndicator(),
          ),
          // ignore: always_specify_types
          loadSuccess: (state) {
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: state.notes.size,
              itemBuilder: (BuildContext context, int index) {
                final Note note = state.notes[index];
                if (note.failureOption.isSome()) {
                  return ErrorNoteCard(note: note);
                } else {
                  return NoteCard(note: note);
                }
              },
            );
          },
          // ignore: always_specify_types
          loadFailure: (state) {
            return CriticalFailureDisplay(failure: state.noteFailure);
          },
        );
      },
    );
  }
}

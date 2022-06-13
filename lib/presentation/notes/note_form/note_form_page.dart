import 'package:another_flushbar/flushbar_helper.dart';
import 'package:auto_route/auto_route.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stratpoint_internship/application/notes/note_form/note_form_bloc.dart';
import 'package:stratpoint_internship/domain/notes/note.dart';
import 'package:stratpoint_internship/domain/notes/note_failure.dart';
import 'package:stratpoint_internship/injection.dart';
import 'package:stratpoint_internship/presentation/routes/router.dart';

class NoteFormPage extends StatelessWidget {
  const NoteFormPage({Key? key, required this.editedNote}) : super(key: key);

  final Note? editedNote;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => getIt<NoteFormBloc>()..add(NoteFormEvent.initialized(optionOf(editedNote))),
      child: BlocConsumer<NoteFormBloc, NoteFormState>(
        listenWhen: (NoteFormState previous, NoteFormState current) => previous.saveFailureOrSuccessOption != current.saveFailureOrSuccessOption,
        listener: (BuildContext context, NoteFormState state) {
          state.saveFailureOrSuccessOption.fold(
            () => {},
            (Either<NoteFailure, Unit> either) {
              either.fold(
                (NoteFailure failure) {
                  FlushbarHelper.createError(
                    message: failure.map(
                      unexpected: (_) => 'Unexpected error occured, please contact support',
                      insufficientPermission: (_) => 'Insufficient Permissions',
                      unableToUpdate: (_) => "Couldn't update the note. Was it deleted from another device?",
                    ),
                  ).show(context);
                },
                (_) {
                  AutoRouter.of(context).popUntilRouteWithName(NotesOverviewPageRoute.name);
                  // ! Check if implemented correctly
                },
              );
            },
          );
        },
        buildWhen: (NoteFormState previous, NoteFormState current) => previous.isSaving != current.isSaving,
        builder: (BuildContext context, NoteFormState state) {
          return Stack(
            children: <Widget>[
              const NoteFormPageScaffold(),
              SavingInProgressOverlay(isSaving: state.isSaving),
            ],
          );
        },
      ),
    );
  }
}

class SavingInProgressOverlay extends StatelessWidget {
  const SavingInProgressOverlay({
    Key? key,
    required this.isSaving,
  }) : super(key: key);

  final bool isSaving;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !isSaving,
      child: SizedBox.expand(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          color: isSaving ? Colors.black.withOpacity(0.8) : Colors.transparent,
          child: Visibility(
            visible: isSaving,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const CircularProgressIndicator(),
                const SizedBox(height: 16.0),
                Text(
                  'Saving',
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NoteFormPageScaffold extends StatelessWidget {
  const NoteFormPageScaffold({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<NoteFormBloc, NoteFormState>(
          buildWhen: (NoteFormState previous, NoteFormState current) => previous.isEditing != current.isEditing,
          builder: (BuildContext context, NoteFormState state) {
            return Text(state.isEditing ? 'Edit Note' : 'Create Note');
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              context.read<NoteFormBloc>().add(const NoteFormEvent.saved());
            },
          )
        ],
      ),
    );
  }
}

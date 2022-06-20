import 'package:another_flushbar/flushbar_helper.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stratpoint_internship/application/auth_bloc.dart';
import 'package:stratpoint_internship/application/notes/note_actor/note_actor_bloc.dart';
import 'package:stratpoint_internship/application/notes/note_watcher/note_watcher_bloc.dart';
import 'package:stratpoint_internship/injection.dart';
import 'package:stratpoint_internship/presentation/notes/notes_overview/widgets/notes_overview_body_widget.dart';
import 'package:stratpoint_internship/presentation/notes/notes_overview/widgets/uncompleted_switch.dart';
import 'package:stratpoint_internship/presentation/routes/router.dart';

class NotesOverviewPage extends StatelessWidget {
  const NotesOverviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider<Bloc<dynamic, dynamic>>>[
        BlocProvider<NoteWatcherBloc>(
          create: (BuildContext context) => getIt<NoteWatcherBloc>()..add(const NoteWatcherEvent.watchAllStarted()),
        ),
        BlocProvider<NoteActorBloc>(
          create: (BuildContext context) => getIt<NoteActorBloc>(),
        ),
      ],
      child: MultiBlocListener(
        listeners: <BlocListener<dynamic, dynamic>>[
          BlocListener<AuthBloc, AuthState>(
            listener: ((BuildContext context, AuthState state) {
              state.maybeMap(
                unauthenticated: (_) => AutoRouter.of(context).push(
                  const SignInPageRoute(),
                ),
                orElse: () {},
              );
            }),
          ),
          BlocListener<NoteActorBloc, NoteActorState>(
            listener: ((BuildContext context, NoteActorState state) {
              state.maybeMap(
                deleteFailure: (state) {
                  FlushbarHelper.createError(
                    duration: const Duration(seconds: 5),
                    message: state.noteFailure.map(
                      unexpected: (_) => 'Unexpected error occured while deleting, please contact support.',
                      insufficientPermission: (_) => 'Insufficient Permissions',
                      unableToUpdate: (_) => 'Impossible Error',
                    ),
                  ).show(context);
                },
                orElse: () {},
              );
            }),
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Notes'),
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                context.read<AuthBloc>().add(const AuthEvent.signedOut());
              },
            ),
            actions: const <Widget>[
              UncompletedSwitch(),
            ],
          ),
          body: const NotesOverviewBody(),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              AutoRouter.of(context).push(
                NoteFormPageRoute(editedNote: null),
              );
            },
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}

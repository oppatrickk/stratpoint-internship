import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:stratpoint_internship/domain/notes/i_note_repository.dart';
import 'package:stratpoint_internship/domain/notes/note.dart';
import 'package:stratpoint_internship/domain/notes/note_failure.dart';

part 'note_actor_event.dart';
part 'note_actor_state.dart';
part 'note_actor_bloc.freezed.dart';

@injectable
class NoteActorBloc extends Bloc<NoteActorEvent, NoteActorState> {
  NoteActorBloc(this._noteRepository) : super(const NoteActorState.initial());

  NoteActorState get initialState => const NoteActorState.initial();

  @override
  Stream<NoteActorState> mapEventToState(
    NoteActorEvent event,
  ) async* {
    yield const NoteActorState.actionInProgress();
    final Either<NoteFailure, Unit> possibleFailure = await _noteRepository.delete(event.note);
    yield possibleFailure.fold(
      (NoteFailure f) => NoteActorState.deleteFailure(f),
      (_) => const NoteActorState.deleteSuccess(),
    );
  }

  final INoteRepository _noteRepository;
}

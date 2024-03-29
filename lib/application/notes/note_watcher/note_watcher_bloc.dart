// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';

import 'package:stratpoint_internship/domain/notes/i_note_repository.dart';
import 'package:stratpoint_internship/domain/notes/note.dart';
import 'package:stratpoint_internship/domain/notes/note_failure.dart';

part 'note_watcher_bloc.freezed.dart';
part 'note_watcher_event.dart';
part 'note_watcher_state.dart';

@injectable
class NoteWatcherBloc extends Bloc<NoteWatcherEvent, NoteWatcherState> {
  NoteWatcherBloc(this._noteRepository) : super(const NoteWatcherState.initial()) {
    on<_WatchAllStarted>(_watchAllStarted);
    on<_WatchUncompletedStarted>(_watchUncompletedStarted);
    on<_NotesReceived>(_notesReceived);
  }

  StreamSubscription<Either<NoteFailure, KtList<Note>>>? _noteStreamSubscription;

  final INoteRepository _noteRepository;

  Future<void> _watchAllStarted(_WatchAllStarted event, Emitter<NoteWatcherState> emit) async {
    emit(const NoteWatcherState.loadInProgress());
    await _noteStreamSubscription?.cancel();
    _noteStreamSubscription = _noteRepository.watchAll().listen((Either<NoteFailure, KtList<Note>> failureOrNotes) => add(
          NoteWatcherEvent.notesReceived(failureOrNotes),
        ));
  }

  Future<void> _watchUncompletedStarted(_WatchUncompletedStarted event, Emitter<NoteWatcherState> emit) async {
    emit(const NoteWatcherState.loadInProgress());
    await _noteStreamSubscription?.cancel();
    _noteStreamSubscription = _noteRepository
        .watchUncompleted()
        .listen((Either<NoteFailure, KtList<Note>> failureOrNotes) => add(NoteWatcherEvent.notesReceived(failureOrNotes)));
  }

  Future<void> _notesReceived(_NotesReceived event, Emitter<NoteWatcherState> emit) async {
    emit(event.failureOrNotes.fold(
      (NoteFailure f) => NoteWatcherState.loadFailure(f),
      (KtList<Note> notes) => NoteWatcherState.loadSuccess(notes),
    ));
  }

  @override
  Future<void> close() async {
    await _noteStreamSubscription?.cancel();
    return super.close();
  }
}

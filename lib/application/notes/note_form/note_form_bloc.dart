import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/kt.dart';
import 'package:stratpoint_internship/domain/notes/i_note_repository.dart';

import 'package:stratpoint_internship/domain/notes/note.dart';
import 'package:stratpoint_internship/domain/notes/note_failure.dart';
import 'package:stratpoint_internship/domain/notes/value_objects.dart';
import 'package:stratpoint_internship/presentation/notes/note_form/misc/todo_item_presentation_classes.dart';

part 'note_form_bloc.freezed.dart';
part 'note_form_event.dart';
part 'note_form_state.dart';

@injectable
class NoteFormBloc extends Bloc<NoteFormEvent, NoteFormState> {
  NoteFormBloc(this._noteRepository) : super(NoteFormState.initial()) {
    on<_Initialized>(_initialized);
    on<_BodyChanged>(_bodyChanged);
    on<_ColorChanged>(_colorChanged);
    on<_TodosChanged>(_todosChanged);
    on<_Saved>(_saved);
  }

  final INoteRepository _noteRepository;

  Future<void> _initialized(_Initialized event, Emitter<NoteFormState> emit) async {
    emit(event.initialNoteOption.fold(
      () => state,
      (Note initialNote) => state.copyWith(
        note: initialNote,
        isEditing: true,
      ),
    ));
  }

  Future<void> _bodyChanged(_BodyChanged event, Emitter<NoteFormState> emit) async {
    emit(state.copyWith(
      note: state.note.copyWith(body: NoteBody(event.bodyStr)),
      saveFailureOrSuccessOption: none(),
    ));
  }

  Future<void> _colorChanged(_ColorChanged event, Emitter<NoteFormState> emit) async {
    emit(state.copyWith(
      note: state.note.copyWith(color: NoteColor(event.color)),
      saveFailureOrSuccessOption: none(),
    ));
  }

  Future<void> _todosChanged(_TodosChanged event, Emitter<NoteFormState> emit) async {
    emit(state.copyWith(
      note: state.note.copyWith(
        todos: List3(event.todos.map((TodoItemPrimitive primitive) => primitive.toDomain())),
      ),
      saveFailureOrSuccessOption: none(),
    ));
  }

  Future<void> _saved(_Saved event, Emitter<NoteFormState> emit) async {
    Either<NoteFailure, Unit>? failureOrSuccess;

    emit(state.copyWith(
      isSaving: true,
      saveFailureOrSuccessOption: none(),
    ));

    if (state.note.failureOption.isNone()) {
      failureOrSuccess = state.isEditing ? await _noteRepository.update(state.note) : await _noteRepository.create(state.note);
    }

    emit(state.copyWith(
      isSaving: false,
      showErrorMessages: AutovalidateMode.always,
      saveFailureOrSuccessOption: optionOf(failureOrSuccess),
    ));
  }
}

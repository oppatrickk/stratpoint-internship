import 'package:dartz/dartz.dart';
import 'package:kt_dart/collection.dart';
import 'package:stratpoint_internship/domain/notes/note.dart';
import 'package:stratpoint_internship/domain/notes/note_failure.dart';

abstract class INoteRepository {
  // Watch Notes
  Stream<Either<NoteFailure, KtList<Note>>> watchAll();

  // Watch Uncompleted Notes
  Stream<Either<NoteFailure, KtList<Note>>> watchUncompleted();

  // CUD - Create, Update, Delete
  Future<Either<NoteFailure, Unit>> create(Note note);
  Future<Either<NoteFailure, Unit>> update(Note note);
  Future<Either<NoteFailure, Unit>> delete(Note note);
}

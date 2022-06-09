// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/kt.dart';
import 'package:rxdart/rxdart.dart';

import 'package:stratpoint_internship/domain/notes/i_note_repository.dart';
import 'package:stratpoint_internship/domain/notes/note.dart';
import 'package:stratpoint_internship/domain/notes/note_failure.dart';
import 'package:stratpoint_internship/domain/notes/todo_item.dart';
import 'package:stratpoint_internship/infastructure/core/firestore_helpers.dart';
import 'package:stratpoint_internship/infastructure/notes/note_dtos.dart';

@LazySingleton(as: INoteRepository)
class NoteRepository implements INoteRepository {
  NoteRepository(
    this._firebaseFirestore,
  );

  final FirebaseFirestore _firebaseFirestore;

  @override
  Stream<Either<NoteFailure, KtList<Note>>> watchAll() async* {
    final DocumentReference<Object?> userDoc = await _firebaseFirestore.userDocument();
    yield* userDoc.noteCollection
        .orderBy('serverTimeStamp', descending: true)
        .snapshots()
        .map(
          (QuerySnapshot<Object?> snapshot) => right<NoteFailure, KtList<Note>>(
            snapshot.docs.map((dynamic doc) => NoteDTO.fromFirestore(doc).toDomain()).toImmutableList(),
          ),
        )
        .onErrorReturnWith((Object e, StackTrace st) {
      if (e is FirebaseException && e.message!.contains('permission-denied')) {
        return left(const NoteFailure.insufficientPermission());
      } else {
        // log.error (e.toString());
        return left(const NoteFailure.unexpected());
      }
    });
  }

  @override
  Stream<Either<NoteFailure, KtList<Note>>> watchUncompleted() async* {
    final DocumentReference<Object?> userDoc = await _firebaseFirestore.userDocument();
    yield* userDoc.noteCollection
        .orderBy('serverTimeStamp', descending: true)
        .snapshots()
        .map(
          (QuerySnapshot<Object?> snapshot) => snapshot.docs.map((dynamic doc) => NoteDTO.fromFirestore(doc).toDomain()),
        )
        .map(
          (Iterable<Note> notes) => right<NoteFailure, KtList<Note>>(
              notes.where((Note note) => note.todos.getorCrash().any((TodoItem todoItem) => !todoItem.done)).toImmutableList()),
        )
        .onErrorReturnWith((Object e, StackTrace st) {
      if (e is FirebaseException && e.message!.contains('permission-denied')) {
        return left(const NoteFailure.insufficientPermission());
      } else {
        // log.error (e.toString());
        return left(const NoteFailure.unexpected());
      }
    });
  }

  @override
  Future<Either<NoteFailure, Unit>> create(Note note) async {
    try {
      final DocumentReference<Object?> userDoc = await _firebaseFirestore.userDocument();
      final NoteDTO noteDTO = NoteDTO.fromDomain(note);

      await userDoc.noteCollection.doc(noteDTO.id).set(noteDTO.toJson());

      return right(unit);
    } on PlatformException catch (e) {
      if (e.message!.contains('permission-denied')) {
        return left(const NoteFailure.insufficientPermission());
      } else {
        return left(const NoteFailure.unexpected());
      }
    }
  }

  @override
  Future<Either<NoteFailure, Unit>> update(Note note) async {
    try {
      final DocumentReference<Object?> userDoc = await _firebaseFirestore.userDocument();
      final NoteDTO noteDTO = NoteDTO.fromDomain(note);

      await userDoc.noteCollection.doc(noteDTO.id).update(noteDTO.toJson());

      return right(unit);
    } on PlatformException catch (e) {
      if (e.message!.contains('permission-denied')) {
        return left(const NoteFailure.insufficientPermission());
      } else if (e.message!.contains('not-found')) {
        return left(const NoteFailure.unableToUpdate());
      } else {
        return left(const NoteFailure.unexpected());
      }
    }
  }

  @override
  Future<Either<NoteFailure, Unit>> delete(Note note) async {
    try {
      final DocumentReference<Object?> userDoc = await _firebaseFirestore.userDocument();
      final String noteId = note.id.getorCrash();

      await userDoc.noteCollection.doc(noteId).delete();

      return right(unit);
    } on PlatformException catch (e) {
      if (e.message!.contains('permission-denied')) {
        return left(const NoteFailure.insufficientPermission());
      } else if (e.message!.contains('permission-denied')) {
        return left(const NoteFailure.unableToUpdate());
      } else {
        return left(const NoteFailure.unexpected());
      }
    }
  }
}

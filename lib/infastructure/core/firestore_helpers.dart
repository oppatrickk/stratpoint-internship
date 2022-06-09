import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:stratpoint_internship/domain/auth/i_auth_facade.dart';
import 'package:stratpoint_internship/domain/auth/user.dart';
import 'package:stratpoint_internship/domain/core/errors.dart';
import 'package:stratpoint_internship/injection.dart';

extension FirestoreX on FirebaseFirestore {
  Future<DocumentReference> userDocument() async {
    final Option<UserID> userOption = await getIt<IAuthFacade>().getSignedInUser();
    final UserID user = userOption.getOrElse(() => throw NotAuthenticatedError());
    return FirebaseFirestore.instance.collection('users').doc(user.id.getorCrash());
  }
}

extension DocumentReferenceX on DocumentReference {
  CollectionReference get noteCollection => collection('notes');
}

import 'package:dartz/dartz.dart';
import 'package:stratpoint_internship/domain/auth/auth_failure.dart';
import 'package:stratpoint_internship/domain/auth/user.dart';
import 'package:stratpoint_internship/domain/auth/value_objects.dart';

abstract class IAuthFacade {
  Future<Option<UserID>> getSignedInUser();
  Future<Either<AuthFailure, Unit>> registerWithEmailAndPassword({
    required EmailAddress emailAddress,
    required Password password,
  });
  Future<Either<AuthFailure, Unit>> signInWithEmailAndPassword({
    required EmailAddress emailAddress,
    required Password password,
  });
  Future<Either<AuthFailure, Unit>> signInWithGoogle();
  Future<void> signOut();
}

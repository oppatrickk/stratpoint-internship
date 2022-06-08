import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'dart:async';

import 'package:stratpoint_internship/domain/auth/auth_failure.dart';
import 'package:stratpoint_internship/domain/auth/i_auth_facade.dart';
import 'package:stratpoint_internship/domain/auth/user.dart';
import 'package:stratpoint_internship/domain/auth/value_objects.dart';
import 'package:stratpoint_internship/infastructure/auth/firebase_user_mapper.dart';

@LazySingleton(as: IAuthFacade)
@Injectable(as: IAuthFacade)
class FirebaseAuthFacade implements IAuthFacade {
  FirebaseAuthFacade(this._googleSignIn, this._firebaseAuth);
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  @override
  Future<Either<AuthFailure, Unit>> registerWithEmailAndPassword({required EmailAddress emailAddress, required Password password}) async {
    final String emailAddressStr = emailAddress.getorCrash();
    final String passwordStr = password.getorCrash();
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailAddressStr, password: passwordStr);

      return right(unit);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return left(const AuthFailure.emailAlreadyInUse());
      } else {
        return left(const AuthFailure.serverError());
      }
    }
  }

  @override
  Future<Either<AuthFailure, Unit>> signInWithEmailAndPassword({required EmailAddress emailAddress, required Password password}) async {
    final String emailAddressStr = emailAddress.getorCrash();
    final String passwordStr = password.getorCrash();
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: emailAddressStr, password: passwordStr);

      return right(unit);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password' || e.code == 'user-not-found') {
        return left(const AuthFailure.invalidEmailAndPasswordCombination());
      } else {
        return left(const AuthFailure.serverError());
      }
    }
  }

  @override
  Future<Either<AuthFailure, Unit>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      return _firebaseAuth.signInWithCredential(credential).then((UserCredential r) => right(unit));
    } on FirebaseAuthException catch (_) {
      return left(const AuthFailure.serverError());
    }
  }

  @override
  Future<Option<UserID>> getSignedInUser() async => optionOf(_firebaseAuth.currentUser?.toDomain());

  @override
  Future<void> signOut() => Future.wait(<Future<void>>[
        _googleSignIn.signOut(),
        _firebaseAuth.signOut(),
      ]);
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import 'package:stratpoint_internship/domain/auth/auth_failure.dart';
import 'package:stratpoint_internship/domain/auth/i_auth_facade.dart';
import 'package:stratpoint_internship/domain/auth/value_objects.dart';

part 'sign_in_form_bloc.freezed.dart';
part 'sign_in_form_event.dart';
part 'sign_in_form_state.dart';

@injectable
class SignInFormBloc extends Bloc<SignInFormEvent, SignInFormState> {
  SignInFormBloc(this._authFacade) : super(SignInFormState.initial()) {
    on<SignInFormEvent>((SignInFormEvent event, Emitter<SignInFormState> emit) {});
    // ! Not being implemented correctly
  }
  final IAuthFacade _authFacade;

  SignInFormState get initialState => SignInFormState.initial();

  Stream<SignInFormState> mapEventToState(
    SignInFormEvent event,
  ) async* {
    yield* event.map(
        // Email Changed
        emailChanged: (EmailChanged e) async* {
      yield state.copyWith(
        emailAddress: EmailAddress(e.emailStr),
        authFailureOrSuccessOption: none(),
      );
    },

        // Password Changed
        passwordChanged: (PasswordChanged e) async* {
      yield state.copyWith(
        password: Password(e.passwordStr),
        authFailureOrSuccessOption: none(),
      );
    },

        // RegisterWithEmailAndPasswordPressed
        registerWithEmailAndPasswordPressed: (RegisterWithEmailAndPasswordPressed e) async* {
      yield* _performActionOnAuthFacadeWithEmailAndPassword(
        _authFacade.registerWithEmailAndPassword,
      );
    },
        // SignInWithEmailAndPasswordPressed
        signInWithEmailAndPasswordPressed: (SignInWithEmailAndPasswordPressed e) async* {
      yield* _performActionOnAuthFacadeWithEmailAndPassword(
        _authFacade.signInWithEmailAndPassword,
      );
    },

        // SignInWithGooglePressed
        signInWithGooglePressed: (SignInWithGooglePressed e) async* {
      yield state.copyWith(
        isSubmitting: true,
        authFailureOrSuccessOption: none(),
      );
      final Either<AuthFailure, Unit> failureOrSuccess = await _authFacade.signInWithGoogle();
      yield state.copyWith(
        isSubmitting: true,
        authFailureOrSuccessOption: some(failureOrSuccess),
      );
    });
  }

  Stream<SignInFormState> _performActionOnAuthFacadeWithEmailAndPassword(
    Future<Either<AuthFailure, Unit>> Function({required EmailAddress emailAddress, required Password password}) forwardedCall,
  ) async* {
    Either<AuthFailure, Unit>? failureOrSuccess;

    final bool isEmailValid = state.emailAddress.isValid();
    final bool isPasswordValid = state.password.isValid();

    if (isEmailValid && isPasswordValid) {
      yield state.copyWith(
        isSubmitting: true,
        authFailureOrSuccessOption: none(),
      );

      failureOrSuccess = await forwardedCall(emailAddress: state.emailAddress, password: state.password);
    }

    yield state.copyWith(
      isSubmitting: false,
      showErrorMessages: AutovalidateMode.always,
      authFailureOrSuccessOption: optionOf(failureOrSuccess),
    );
  }
}

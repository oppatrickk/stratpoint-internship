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
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<RegisterWithEmailAndPasswordPressed>(_onRegisterWithEmailAndPasswordPressed);
    on<SignInWithEmailAndPasswordPressed>(_onSignInWithEmailAndPasswordPressed);
    on<SignInWithGooglePressed>(_onSignInWithGooglePressed);
  }

  final IAuthFacade _authFacade;

  Future<void> _onEmailChanged(EmailChanged event, Emitter<SignInFormState> emit) async {
    emit(state.copyWith(
      emailAddress: EmailAddress(event.emailStr),
      authFailureOrSuccessOption: none(),
    ));
  }

  Future<void> _onPasswordChanged(PasswordChanged event, Emitter<SignInFormState> emit) async {
    emit(state.copyWith(
      password: Password(event.passwordStr),
      authFailureOrSuccessOption: none(),
    ));
  }

  Future<void> _onRegisterWithEmailAndPasswordPressed(
    RegisterWithEmailAndPasswordPressed event,
    Emitter<SignInFormState> emit,
  ) async {
    Either<AuthFailure, Unit>? failureOrSuccess;

    final bool isEmailValid = state.emailAddress.isValid();
    final bool isPasswordValid = state.password.isValid();

    if (isEmailValid && isPasswordValid) {
      emit(state.copyWith(
        isSubmitting: true,
        authFailureOrSuccessOption: none(),
      ));

      failureOrSuccess = await _authFacade.registerWithEmailAndPassword(emailAddress: state.emailAddress, password: state.password);
    }

    emit(state.copyWith(
      isSubmitting: false,
      showErrorMessages: AutovalidateMode.always,
      authFailureOrSuccessOption: optionOf(failureOrSuccess),
    ));
  }

  Future<void> _onSignInWithEmailAndPasswordPressed(
    SignInWithEmailAndPasswordPressed event,
    Emitter<SignInFormState> emit,
  ) async {
    Either<AuthFailure, Unit>? failureOrSuccess;

    final bool isEmailValid = state.emailAddress.isValid();
    final bool isPasswordValid = state.password.isValid();

    if (isEmailValid && isPasswordValid) {
      emit(state.copyWith(
        isSubmitting: true,
        authFailureOrSuccessOption: none(),
      ));

      failureOrSuccess = await _authFacade.signInWithEmailAndPassword(emailAddress: state.emailAddress, password: state.password);
    }

    emit(state.copyWith(
      isSubmitting: false,
      showErrorMessages: AutovalidateMode.always,
      authFailureOrSuccessOption: optionOf(failureOrSuccess),
    ));
  }

  // Sign In With Google
  Future<void> _onSignInWithGooglePressed(SignInWithGooglePressed event, Emitter<SignInFormState> emit) async {
    emit(state.copyWith(
      isSubmitting: true,
      authFailureOrSuccessOption: none(),
    ));

    final Either<AuthFailure, Unit> failureOrSuccess = await _authFacade.signInWithGoogle();

    emit(state.copyWith(
      isSubmitting: true,
      authFailureOrSuccessOption: some(failureOrSuccess),
    ));
  }
}

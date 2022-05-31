import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:stratpoint_internship/domain/auth/auth_failure.dart';
import 'package:stratpoint_internship/domain/auth/i_auth_facade.dart';
import 'package:stratpoint_internship/domain/auth/value_objects.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'dart:async';

part 'sign_in_form_event.dart';
part 'sign_in_form_state.dart';

part 'sign_in_form_bloc.freezed.dart';

class SignInFormBloc extends Bloc<SignInFormEvent, SignInFormState> {
  final IAuthFacade _authFacade;

  SignInFormBloc(this._authFacade);

  @override
  SignInFormState get InitialState => SignInFormState.initial();

  @override
  Stream<SignInFormState> mapEventToState(
    SignInFormEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}

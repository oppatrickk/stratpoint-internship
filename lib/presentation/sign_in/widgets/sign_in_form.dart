import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:stratpoint_internship/application/auth/sign_in_form/sign_in_form_bloc.dart';
import 'package:stratpoint_internship/domain/auth/auth_failure.dart';
import 'package:stratpoint_internship/domain/core/failures.dart';

class SignInForm extends StatelessWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInFormBloc, SignInFormState>(
      listener: (BuildContext context, SignInFormState state) {
        state.authFailureOrSuccessOption.fold(
          () {},
          (Either<AuthFailure, Unit> either) => either.fold(
            (AuthFailure failure) {
              FlushbarHelper.createError(
                message: failure.map(
                  cancelledByUser: (_) => 'Cancelled',
                  serverError: (_) => 'Server Error',
                  emailAlreadyInUse: (_) => 'Email already in use',
                  invalidEmailAndPasswordCombination: (_) => 'Invalid email and password combination',
                ),
              ).show(context);
            },
            (_) => {
              // Todo: Navigate
            },
          ),
        );
      },
      builder: (BuildContext context, SignInFormState state) {
        return Form(
          autovalidateMode: state.showErrorMessages,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const SizedBox(height: 16),
              const Text(
                '📝',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 120),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  labelText: 'Email',
                ),
                autocorrect: false,
                onChanged: (String value) => context.read<SignInFormBloc>().add(SignInFormEvent.emailChanged(value)),
                validator: (_) => context.read<SignInFormBloc>().state.emailAddress.value.fold(
                    (ValueFailure<String> f) => f.maybeMap(
                          invalidEmail: (_) => 'Invalid Email',
                          orElse: () => null,
                        ),
                    (_) => null),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  labelText: 'Password',
                ),
                autocorrect: false,
                obscureText: true,
                onChanged: (String value) => context.read<SignInFormBloc>().add(SignInFormEvent.passwordChanged(value)),
                validator: (_) => context.read<SignInFormBloc>().state.password.value.fold(
                    (ValueFailure<String> f) => f.maybeMap(
                          shortPassword: (_) => 'Short Password',
                          orElse: () => null,
                        ),
                    (_) => null),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {
                      context.read<SignInFormBloc>().add(
                            const SignInFormEvent.signInWithEmailAndPasswordPressed(),
                          );
                    },
                    child: const Text('Sign In'),
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<SignInFormBloc>().add(
                            const SignInFormEvent.registerWithEmailAndPasswordPressed(),
                          );
                    },
                    child: const Text('Register'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  context.read<SignInFormBloc>().add(
                        const SignInFormEvent.signInWithGooglePressed(),
                      );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue, // backgroundforeground
                ),
                child: const Text('Sign in with Google'),
              ),
            ],
          ),
        );
      },
    );
  }
}

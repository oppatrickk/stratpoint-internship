import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:stratpoint_internship/application/auth/sign_in_form/sign_in_form_bloc.dart';
import 'package:stratpoint_internship/injection.dart';
import 'package:stratpoint_internship/presentation/sign_in/widgets/sign_in_form.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Sign In'),
      ),
      body: BlocProvider<SignInFormBloc>(
        create: (BuildContext context) => getIt<SignInFormBloc>(),
        child: const SignInForm(),
      ),
    );
  }
}

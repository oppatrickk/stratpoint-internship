// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:firebase_auth/firebase_auth.dart' as i3;
import 'package:get_it/get_it.dart' as i1;
import 'package:google_sign_in/google_sign_in.dart' as i4;
import 'package:injectable/injectable.dart' as i2;

import 'application/auth/sign_in_form/sign_in_form_bloc.dart' as i7;
import 'application/auth_bloc.dart' as i8;
import 'domain/auth/i_auth_facade.dart' as i5;
import 'infastructure/auth/firebase_auth_facade.dart' as i6;
import 'infastructure/core/firebase_injectable_module.dart' as i9; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
i1.GetIt $initGetIt(i1.GetIt get, {String? environment, i2.EnvironmentFilter? environmentFilter}) {
  final i2.GetItHelper gh = i2.GetItHelper(get, environment, environmentFilter);
  final _$FirebaseInjectableModule firebaseInjectableModule = _$FirebaseInjectableModule();
  gh.lazySingleton<i3.FirebaseAuth>(() => firebaseInjectableModule.firebaseAuth);
  gh.lazySingleton<i4.GoogleSignIn>(() => firebaseInjectableModule.googleSignIn);
  gh.lazySingleton<i5.IAuthFacade>(() => i6.FirebaseAuthFacade(get<i4.GoogleSignIn>(), get<i3.FirebaseAuth>()));
  gh.factory<i7.SignInFormBloc>(() => i7.SignInFormBloc(get<i5.IAuthFacade>()));
  gh.factory<i8.AuthBloc>(() => i8.AuthBloc(get<i5.IAuthFacade>()));
  return get;
}

class _$FirebaseInjectableModule extends i9.FirebaseInjectableModule {}

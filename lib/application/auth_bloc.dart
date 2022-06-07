import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:stratpoint_internship/domain/auth/i_auth_facade.dart';
import 'package:stratpoint_internship/domain/auth/user.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._authFacade) : super(const AuthState.initial());

  AuthState get initialState => const AuthState.initial();

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    yield* event.map(
      authCheckRequested: (AuthCheckRequested e) async* {
        final Option<UserID> userOption = await _authFacade.getSignedInUser();
        yield userOption.fold(
          () => const AuthState.unauthenticated(),
          (_) => const AuthState.authenticated(),
        );
      },
      signedOut: (SignedOut e) async* {
        await _authFacade.signOut();
        yield const AuthState.unauthenticated();
      },
    );
  }

  /*
  AuthBloc() : super(const Initial()) {
    on<AuthEvent>((AuthEvent event, Emitter<AuthState> emit) {});
  }
  TODO: Migrate to Bloc 8

  */

  final IAuthFacade _authFacade;
}

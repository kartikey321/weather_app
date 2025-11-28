import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/features/auth/domain/usecases/check_auth_status.dart';
import 'package:weather_app/features/auth/domain/usecases/get_current_user.dart';
import 'package:weather_app/features/auth/domain/usecases/login.dart';
import 'package:weather_app/features/auth/domain/usecases/logout.dart';
import 'package:weather_app/features/auth/domain/usecases/register.dart';
import 'package:weather_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:weather_app/features/auth/presentation/bloc/auth_state.dart';

/// Authentication BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login loginUseCase;
  final Register registerUseCase;
  final Logout logoutUseCase;
  final CheckAuthStatus checkAuthStatusUseCase;
  final GetCurrentUser getCurrentUserUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
    required this.checkAuthStatusUseCase,
    required this.getCurrentUserUseCase,
  }) : super(const AuthInitial()) {
    print('🔷 AuthBloc created');
    print('  - loginUseCase: $loginUseCase');
    print('  - registerUseCase: $registerUseCase');
    print('  - logoutUseCase: $logoutUseCase');
    print('  - checkAuthStatusUseCase: $checkAuthStatusUseCase');
    print('  - getCurrentUserUseCase: $getCurrentUserUseCase');

    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<LogoutEvent>(_onLogout);
  }

  /// Handle check auth status event
  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await checkAuthStatusUseCase();

    await result.fold(
      (failure) async {
        emit(const Unauthenticated());
      },
      (isAuthenticated) async {
        if (isAuthenticated) {
          // Get current user
          final userResult = await getCurrentUserUseCase();
          userResult.fold(
            (failure) => emit(const Unauthenticated()),
            (user) {
              if (user != null) {
                emit(Authenticated(user));
              } else {
                emit(const Unauthenticated());
              }
            },
          );
        } else {
          emit(const Unauthenticated());
        }
      },
    );
  }

  /// Handle login event
  Future<void> _onLogin(
    LoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    print('🔷 AuthBloc: Login event received');
    print('  - Email: ${event.email}');

    emit(const AuthLoading());
    print('🔷 AuthBloc: Emitted AuthLoading state');

    final params = LoginParams(
      email: event.email,
      password: event.password,
    );

    print('🔷 AuthBloc: Calling loginUseCase...');
    try {
      final result = await loginUseCase(params);
      print('🔷 AuthBloc: loginUseCase returned result');

      result.fold(
        (failure) {
          print('🔷 AuthBloc: Login failed - ${failure.message}');
          emit(AuthError(failure.message));
        },
        (user) {
          print('🔷 AuthBloc: Login successful - User: ${user.name}');
          emit(Authenticated(user));
        },
      );
    } catch (e, stackTrace) {
      print('🔷 AuthBloc: Exception in login: $e');
      print('Stack trace: $stackTrace');
      emit(AuthError('Login failed: ${e.toString()}'));
    }
  }

  /// Handle register event
  Future<void> _onRegister(
    RegisterEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final params = RegisterParams(
      name: event.name,
      email: event.email,
      password: event.password,
    );

    final result = await registerUseCase(params);

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(Authenticated(user)),
    );
  }

  /// Handle logout event
  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await logoutUseCase();

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(const Unauthenticated()),
    );
  }
}

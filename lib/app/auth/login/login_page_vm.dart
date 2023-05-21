import 'package:caffeio/app/mvvm/view_model.abs.dart';
import 'package:caffeio/app/router/route_spec.dart';
import 'package:caffeio/domain/models/auth/user_login.dart';
import 'package:caffeio/domain/use_cases/auth/sign_in_with_password_uc.dart';
import 'package:caffeio/domain/use_cases/brew/fetch_user_brews_uc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

class LoginPageState extends Equatable {
  final String email;
  final String password;
  final String? error;

  const LoginPageState({
    this.email = '',
    this.password = '',
    this.error,
  });

  LoginPageState copyWith({
    String? email,
    String? password,
    String? error,
  }) =>
      LoginPageState(
        email: email ?? this.email,
        password: password ?? this.password,
        error: error ?? this.error,
      );

  @override
  List<Object?> get props => [
        email,
        password,
        error,
      ];
}

class LoginPageViewModel extends ViewModel {
  final SignInWithPasswordUseCase _signInUseCase;
  final FetchUserBrewsUseCase _fetchUserBrewsUseCase;

  final _state = BehaviorSubject<LoginPageState>.seeded(const LoginPageState());

  Stream<LoginPageState> get state => _state.stream;

  final _router = BehaviorSubject<RouteSpec>();

  Stream<RouteSpec> get router => _router;

  LoginPageViewModel(
    this._signInUseCase,
    this._fetchUserBrewsUseCase,
  );

  @override
  void init() {}

  Future<void> onLogin() async {
    if (_state.value.email.isEmpty) {
      _state.add(_state.value.copyWith(error: 'Invalid email'));
      return;
    }
    if (_state.value.password.isEmpty) {
      _state.add(_state.value.copyWith(error: 'Invalid password'));
      return;
    }
    await login();
  }

  Future<void> login() async {
    final loginData = UserLogin(
      email: _state.value.email,
      password: _state.value.password,
    );
    final result = await _signInUseCase.call(loginData);
    await _fetchUserBrewsUseCase();
    if (result) {
      _router.add(RouteSpec.pop());
    }
  }

  void onChangePassword(String value) {
    _state.add(_state.value.copyWith(password: value));
  }

  void onChangeEmail(String value) {
    _state.add(_state.value.copyWith(email: value));
  }

  @override
  void dispose() {}
}

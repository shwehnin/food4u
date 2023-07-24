part of 'users_bloc.dart';

@immutable
abstract class UsersState {
  const UsersState();
  List<Object> get props => [];
}

class InitialUsersState extends UsersState {}

// User Login State
class UserLoginLoadInProgress extends UsersState {}

class UserLoginLoadSuccess extends UsersState {
  final Map<dynamic, dynamic> userData;

  const UserLoginLoadSuccess({required this.userData});

  @override
  List<Object> get props => [userData];
}

class UserLoginLoadFailure extends UsersState{
  final Object message;
  const UserLoginLoadFailure({required this.message});

  @override
  List<Object> get props => [message];
}

//User Account Create State
class UserCreateAccountLoadInProgress extends UsersState {}

class UserCreateAccountLoadSuccess extends UsersState {
  final Map<dynamic, dynamic> userData;
  const UserCreateAccountLoadSuccess({required this.userData});

  @override
  List<Object> get props => [userData];
}

class UserCreateAccountLoadFailure extends UsersState{
  final Object message;
  const UserCreateAccountLoadFailure({required this.message});

  @override
  List<Object> get props => [message];
}

//User facebook Login
class UserLoginFacebookLoadInProgress extends UsersState {}

class UserLoginFacebookLoadSuccess extends UsersState {
  final Map<dynamic, dynamic> userData;
  const UserLoginFacebookLoadSuccess({required this.userData});

  @override
  List<Object> get props => [userData];
}

class UserLoginFacebookLoadFailure extends UsersState{
  final Object message;
  const UserLoginFacebookLoadFailure({required this.message});

  @override
  List<Object> get props => [message];
}


//User facebook Register
class UserRegisterFacebookLoadInProgress extends UsersState {}

class UserRegisterFacebookLoadSuccess extends UsersState {
  final Map<dynamic, dynamic> userData;
  const UserRegisterFacebookLoadSuccess({required this.userData});

  @override
  List<Object> get props => [userData];
}

class UserRegisterFacebookLoadFailure extends UsersState{
  final Object message;
  const UserRegisterFacebookLoadFailure({required this.message});

  @override
  List<Object> get props => [message];
}


//User forgot password
class UserForgotPasswordLoadInProgress extends UsersState {}

class UserForgotPasswordLoadSuccess extends UsersState {
  final String message;
  const UserForgotPasswordLoadSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class UserForgotPasswordLoadFailure extends UsersState{
  final Object message;
  const UserForgotPasswordLoadFailure({required this.message});

  @override
  List<Object> get props => [message];
}

//User reset password
class UserResetPasswordLoadInProgress extends UsersState {}

class UserResetPasswordLoadSuccess extends UsersState {
  final Map<dynamic, dynamic> userData;
  const UserResetPasswordLoadSuccess({required this.userData});

  @override
  List<Object> get props => [userData];
}

class UserResetPasswordLoadFailure extends UsersState{
  final Object message;
  const UserResetPasswordLoadFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class UserLogoutLoadInProgress extends UsersState {}

class UserLogoutLoadSuccess extends UsersState {
  final Map<dynamic, dynamic> userData;
  const UserLogoutLoadSuccess({required this.userData});

  @override
  List<Object> get props => [userData];
}

class UserLogoutLoadFailure extends UsersState{}




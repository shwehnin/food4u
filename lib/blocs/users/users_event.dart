part of 'users_bloc.dart';

@immutable
abstract class UsersEvent extends Equatable {
  const UsersEvent();
}

class InitialLoginRequested extends UsersEvent {

  InitialLoginRequested();

  @override
  List<Object> get props => [];
}

class UserLoginRequested extends UsersEvent {
  final String phone;
  final String password;
  final String fcmToken;

  UserLoginRequested({
    required this.phone,
    required this.password,
    required this.fcmToken,
  });

  @override
  List<Object> get props => [
        phone,
        password,
        fcmToken,
      ];
}

class UserCreateAccountRequested extends UsersEvent {
  final String name;
  final String phone;
  final String password;
  final String deliveryLocation;
  final int deliveryAreaId;
  final String fcmToken;

  UserCreateAccountRequested(
      {required this.name,
      required this.phone,
      required this.password,
      required this.deliveryLocation,
      required this.deliveryAreaId,
      required this.fcmToken});

  @override
  List<Object?> get props =>
      [name, phone, password, deliveryLocation, deliveryAreaId, fcmToken];
}

class UserLoginFacebookRequested extends UsersEvent {
  final String facebookId;
  final String fcmToken;

  UserLoginFacebookRequested(
      {required this.facebookId,
      required this.fcmToken});

  @override
  List<Object?> get props => [facebookId, fcmToken];
}

class UserRegisterFacebookRequested extends UsersEvent {
  final String facebookId;
  final String name;
  //final String phone;
  final String email;
  //final String deliveryLocation;
  //final int deliveryAreaId;
  final String fcmToken;

  UserRegisterFacebookRequested(
      {required this.facebookId,
      required this.name,
      //required this.phone,
      required this.email,
      //required this.deliveryLocation,
      //required this.deliveryAreaId,
      required this.fcmToken});

  @override
  List<Object?> get props =>  [facebookId, name, email,  fcmToken];
      //[facebookId,name, phone, email, deliveryLocation, deliveryAreaId, fcmToken];
}

class UserForgotPasswordRequested extends UsersEvent {
  final String phone;

  UserForgotPasswordRequested({required this.phone});

  @override
  List<Object?> get props => [
        phone,
      ];
}

class UserResetPasswordRequested extends UsersEvent {
  final String phone;
  final String password;
  final String confirmPassword;
  final String fcmToken;

  UserResetPasswordRequested(
      {required this.phone,
      required this.password,
      required this.confirmPassword,
      required this.fcmToken});

  @override
  List<Object?> get props => [phone, password, confirmPassword, fcmToken];
}

class UserLogoutRequested extends UsersEvent {
  final String token;

  UserLogoutRequested(
      {required this.token});

  @override
  List<Object?> get props => [token];
}




part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
}

class InitialProfileLoginRequested extends ProfileEvent {

  InitialProfileLoginRequested();

  @override
  List<Object> get props => [];
}

class ProfileRequested extends ProfileEvent {
  final String token;
  final bool isFirstTime;

  ProfileRequested({required this.token, required this.isFirstTime});

  @override
  List<Object> get props => [token, isFirstTime];
}

class ProfileLocationUpdateRequested extends ProfileEvent {
  final String token;
  final String customerName;
  final String deliveryLocation;
  final int deliAreasId;
  final String email;
  final BuildContext context;

  ProfileLocationUpdateRequested(
      {required this.token,
      required this.customerName,
      required this.deliveryLocation,
      required this.deliAreasId,
      required this.email, 
      required this.context});

  @override
  List<Object?> get props =>
      [token, customerName, deliveryLocation, deliAreasId, email,context];
}

class ProfileNameEmailUpdateRequested extends ProfileEvent {
  final String token;
  final String customerName;
  final String email;

  ProfileNameEmailUpdateRequested(
      {required this.token, required this.customerName, required this.email});

  @override
  List<Object?> get props => [token, customerName, email];
}

class ProfilePhoneUpdateRequested extends ProfileEvent {
  final String token;
  final String phone;

  ProfilePhoneUpdateRequested({required this.token, required this.phone});

  @override
  List<Object?> get props => [token, phone];
}

class ProfileVerifyPhoneUpdateRequested extends ProfileEvent {
  final String token;
  final String phone;

  ProfileVerifyPhoneUpdateRequested({required this.token, required this.phone});

  @override
  List<Object?> get props => [token, phone];
}

class ProfilePasswordUpdateRequested extends ProfileEvent {
  final String token;
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;
  final BuildContext context;

  ProfilePasswordUpdateRequested(
      {required this.token,
      required this.currentPassword,
      required this.newPassword,
      required this.confirmPassword, 
      required this.context});

  @override
  List<Object?> get props =>
      [token, currentPassword, newPassword, confirmPassword, context];
}

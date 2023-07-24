part of 'profile_bloc.dart';

@immutable
abstract class ProfileState {
  const ProfileState();
  List<Object> get props => [];
}

class InitialProfileState extends ProfileState {}

class ProfileLoadInProgress extends ProfileState {}

class ProfileLoadSuccess extends ProfileState {
  final User profile;
  const ProfileLoadSuccess({required this.profile});
  @override
  List<Object> get props => [profile];
}

class ProfileLoadFailure extends ProfileState {
  final Object message;
  const ProfileLoadFailure({required this.message});

  @override
  List<Object> get props => [message];
}

// Update Profile Location
class UpdateProfileInformationLoadInProgress extends ProfileState {}

class UpdateProfileInformationLoadSuccess extends ProfileState {
  final Map<dynamic, dynamic> updatedProfile;
  const UpdateProfileInformationLoadSuccess({required this.updatedProfile});
  @override
  List<Object> get props => [updatedProfile];
}

class UpdateProfileInformationLoadFailure extends ProfileState {}

// Update Profile Phone
class UpdateProfilePhoneLoadInProgress extends ProfileState {}

class UpdateProfilePhoneLoadSuccess extends ProfileState {
  final Map<String, dynamic> updatedProfile;
  const UpdateProfilePhoneLoadSuccess({required this.updatedProfile});
  @override
  List<Object> get props => [updatedProfile];
}

class UpdateProfilePhoneLoadFailure extends ProfileState {}

// Verify Profile Phone
class VerifyProfilePhoneLoadInProgress extends ProfileState {}

class VerifyProfilePhoneLoadSuccess extends ProfileState {
  final User updatedProfile;
  const VerifyProfilePhoneLoadSuccess({required this.updatedProfile});
  @override
  List<Object> get props => [updatedProfile];
}

class VerifyProfilePhoneLoadFailure extends ProfileState {}

// Update Profile Password
class UpdateProfilePasswordLoadInProgress extends ProfileState {}

class UpdateProfilePasswordLoadSuccess extends ProfileState {
  final Map<dynamic, dynamic> updatedMessage;
  const UpdateProfilePasswordLoadSuccess({required this.updatedMessage});
  @override
  List<Object> get props => [updatedMessage];
}

class UpdateProfilePasswordLoadFailure extends ProfileState {}


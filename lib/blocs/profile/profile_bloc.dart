import 'dart:async';
import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/data/repositories/ecommerce_repository.dart';
import 'package:bestcannedfood_ecommerce/model/models.dart';
import 'package:bestcannedfood_ecommerce/translations/locale_keys.g.dart';
import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final EcommerceRepository ecommerceRepository;

  ProfileBloc({required this.ecommerceRepository})
      : super(InitialProfileState());

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    // Get Profile information
    if (event is ProfileRequested) {
      yield* _mapProfileRequestedToState(event);
    }

    // Update Profile Location information
    if (event is ProfileLocationUpdateRequested) {
      yield* _mapUpdateProfileLocationRequestedToState(event);
    }

    // Update Profile Phone information
    if (event is ProfilePhoneUpdateRequested) {
      yield* _mapUpdateProfilePhoneRequestedToState(event);
    }

    // Verify Profile Phone information
    if (event is ProfileVerifyPhoneUpdateRequested) {
      yield* _mapVerifyProfilePhoneRequestedToState(event);
    }

    // Verify Profile Passwrod information
    if (event is ProfilePasswordUpdateRequested) {
      yield* _mapUpdateProfilePasswordRequestedToState(event);
    }
  }

  // Get Profile information
  Stream<ProfileState> _mapProfileRequestedToState(
    ProfileRequested event,
  ) async* {
    if (event.isFirstTime) {
      yield ProfileLoadInProgress();
    }

    try {
      final User profile = await ecommerceRepository.getProfile(
        event.token,
      );
      yield ProfileLoadSuccess(profile: profile);
    } catch (error) {
      yield ProfileLoadFailure(message: error);
    }
  }

  // Update Profile Location information
  Stream<ProfileState> _mapUpdateProfileLocationRequestedToState(
    ProfileLocationUpdateRequested event,
  ) async* {
    //yield UpdateProfileInformationLoadInProgress();

    try {
      final Map<dynamic, dynamic> updatedProfile =
          await ecommerceRepository.updateProfileLocation(
        event.token,
        event.customerName,
        event.deliveryLocation,
        event.deliAreasId,
        event.email,
      );

      showSuccessMessage(LocaleKeys.updated_profile.tr());

      UpdateProfileInformationLoadSuccess(updatedProfile: updatedProfile);
    } catch (_) {
      yield UpdateProfileInformationLoadFailure();
    }
  }

  // Update Profile Phone information
  Stream<ProfileState> _mapUpdateProfilePhoneRequestedToState(
    ProfilePhoneUpdateRequested event,
  ) async* {
    //yield UpdateProfileInformationLoadInProgress();

    try {
      final Map<String, dynamic> updatedProfile =
          await ecommerceRepository.updateProfilePhone(
        event.token,
        event.phone,
      );
      yield UpdateProfilePhoneLoadSuccess(updatedProfile: updatedProfile);
    } catch (error) {
      var data = error.toString().replaceAll('Exception: ', '');
      String message = data;
      EasyLoading.showError(message, duration: Duration(seconds: 3));
      yield UpdateProfilePhoneLoadFailure();
    }
  }

  // Verify Profile Phone information
  Stream<ProfileState> _mapVerifyProfilePhoneRequestedToState(
    ProfileVerifyPhoneUpdateRequested event,
  ) async* {
    yield VerifyProfilePhoneLoadInProgress();
    final User updatedProfile = await ecommerceRepository.verifyProfilePhone(
      event.token,
      event.phone,
    );
    yield VerifyProfilePhoneLoadSuccess(updatedProfile: updatedProfile);

    yield ProfileLoadSuccess(profile: updatedProfile);
    print("phone verify $updatedProfile");
    try {} catch (_) {
      yield VerifyProfilePhoneLoadFailure();
    }
  }

  // Update Profile Password information
  Stream<ProfileState> _mapUpdateProfilePasswordRequestedToState(
    ProfilePasswordUpdateRequested event,
  ) async* {
    //yield UpdateProfilePasswordLoadInProgress();

    try {
      final Map<dynamic, dynamic> updatedMessage =
          await ecommerceRepository.updateProfilePassword(
        event.token,
        event.currentPassword,
        event.newPassword,
        event.confirmPassword,
      );

      if (updatedMessage['success']) {
        EasyLoading.showSuccess(updatedMessage['message']);
        yield UpdateProfilePasswordLoadSuccess(updatedMessage: updatedMessage);
      }
    } catch (error) {
      var data = error.toString().replaceAll('Exception: ', '');
      String message = data;
      showToast(
        message,
      );
      //yield UpdateProfilePasswordLoadFailure();
    }
  }
}

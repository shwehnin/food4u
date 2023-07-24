import 'dart:async';
import 'package:bestcannedfood_ecommerce/data/repositories/ecommerce_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final EcommerceRepository ecommerceRepository;

  UsersBloc({required this.ecommerceRepository}) : super(InitialUsersState());

  @override
  Stream<UsersState> mapEventToState(UsersEvent event) async* {
    // User Login
    if (event is UserLoginRequested) {
      yield* _mapUserLoginRequestedToState(event);
    }

    if (event is UserCreateAccountRequested) {
      yield* _mapUserCreateAccountRequestedToState(event);
    }

    if (event is UserRegisterFacebookRequested) {
      yield* _mapUserRegisterFacebookRequestedToState(event);
    }

    if (event is UserForgotPasswordRequested) {
      yield* _mapUserForgotPasswordRequestedToState(event);
    }

    if (event is UserResetPasswordRequested) {
      yield* _mapUserResetPasswordRequestedToState(event);
    }
    if (event is UserLogoutRequested) {
      yield* _mapUserLogoutRequestedToState(event);
    }
  }

  // User Login map event to state
  Stream<UsersState> _mapUserLoginRequestedToState(
    UserLoginRequested event,
  ) async* {
    yield UserLoginLoadInProgress();

    try {
      final Map<dynamic, dynamic> userData = await ecommerceRepository
          .getUserLogin(event.phone, event.password, event.fcmToken);
      yield UserLoginLoadSuccess(userData: userData);
    } catch (error) {
      yield UserLoginLoadFailure(message: error);
    }
  }

  Stream<UsersState> _mapUserCreateAccountRequestedToState(
    UserCreateAccountRequested event,
  ) async* {
    yield UserCreateAccountLoadInProgress();
    try {
      final Map<dynamic, dynamic> userData =
          await ecommerceRepository.createUserAccount(
              event.name,
              event.phone,
              event.password,
              event.deliveryLocation,
              event.deliveryAreaId,
              event.fcmToken);
      yield UserCreateAccountLoadSuccess(userData: userData);
    } catch (error) {
      yield UserCreateAccountLoadFailure(message: error);
    }
  }

  Stream<UsersState> _mapUserRegisterFacebookRequestedToState(
    UserRegisterFacebookRequested event,
  ) async* {
    yield UserRegisterFacebookLoadInProgress();

    try {
      final Map<dynamic, dynamic> userData =
          await ecommerceRepository.registerWithFacebook(
              event.facebookId,
              event.name,
              //event.phone,
              event.email,
              // event.deliveryLocation,
              //event.deliveryAreaId,
              event.fcmToken);
      yield UserRegisterFacebookLoadSuccess(userData: userData);
    } catch (error) {
      yield UserRegisterFacebookLoadFailure(message: error);
    }
  }

  Stream<UsersState> _mapUserForgotPasswordRequestedToState(
    UserForgotPasswordRequested event,
  ) async* {
    yield UserForgotPasswordLoadInProgress();
    try {
      final String message =
          await ecommerceRepository.getForgotPassword(event.phone);
      yield UserForgotPasswordLoadSuccess(message: message);
    } catch (error) {
      yield UserForgotPasswordLoadFailure(message: error);
    }
  }

  Stream<UsersState> _mapUserResetPasswordRequestedToState(
    UserResetPasswordRequested event,
  ) async* {
    yield UserResetPasswordLoadInProgress();

    final Map<dynamic, dynamic> userData =
        await ecommerceRepository.getResetPassword(
            event.phone, event.password, event.confirmPassword, event.fcmToken);
    yield UserResetPasswordLoadSuccess(userData: userData);
    /*
    try {
      
    } catch (error) {
      yield UserResetPasswordLoadFailure(message: error);
    }*/
  }

  Stream<UsersState> _mapUserLogoutRequestedToState(
    UserLogoutRequested event,
  ) async* {
    //yield UserLogoutLoadInProgress();

    try {
      final Map<dynamic, dynamic> userData =
          await ecommerceRepository.getLogout(event.token);
      yield UserLogoutLoadSuccess(userData: userData);
    } catch (_) {
      yield UserLogoutLoadFailure();
    }
  }
}

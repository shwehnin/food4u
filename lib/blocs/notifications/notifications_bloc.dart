import 'dart:async';

import 'package:bestcannedfood_ecommerce/data/repositories/ecommerce_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final EcommerceRepository ecommerceRepository;
  NotificationsBloc({required this.ecommerceRepository})
      : super(NotificationsInitial());

  @override
  Stream<NotificationsState> mapEventToState(
    NotificationsEvent event,
  ) async* {
    if (event is NotificationsListRequested) {
      yield* _mapNotificationsListRequestedToState(event);
    }

    if (event is NotificationsDetailsRequested) {
      yield* _mapNotificationsDetailsRequestedToState(event);
    }

    if (event is NotificationsListDeleteRequested) {
      yield* _mapNotificationsListDeleteRequestedToState(event);
    }
  }

  Stream<NotificationsState> _mapNotificationsListRequestedToState(
    NotificationsListRequested event,
  ) async* {
    yield NotificationsLoading();

    try {
      final Map<dynamic, dynamic> notifications =
          await ecommerceRepository.getNotificationList(event.token);
      yield NotificationsLoadSuccess(notifications: notifications);
    } catch (_) {
      yield NotificationsLoadFailure();
    }
  }

  Stream<NotificationsState> _mapNotificationsDetailsRequestedToState(
    NotificationsDetailsRequested event,
  ) async* {
    yield NotificationsLoading();

    try {
      final Map<dynamic, dynamic> notifications = await ecommerceRepository
          .getNotificationDetails(event.token, event.notificationId);
      yield NotificationsDetailsLoadSuccess(notification: notifications);
    } catch (_) {
      yield NotificationsDetailsLoadFailure();
    }
  }

  Stream<NotificationsState> _mapNotificationsListDeleteRequestedToState(
    NotificationsListDeleteRequested event,
  ) async* {
    try {
      final String message = await ecommerceRepository.getNotificationDelete(
          event.token, event.id);
      EasyLoading.showSuccess(message, duration: Duration(milliseconds: 1000));

      final Map<dynamic, dynamic> notifications =
          await ecommerceRepository.getNotificationList(event.token);
      yield NotificationsLoadSuccess(notifications: notifications);
    } catch (error) {}
  }
}

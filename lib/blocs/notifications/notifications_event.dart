part of 'notifications_bloc.dart';

@immutable
abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();
}

// ignore: must_be_immutable
class NotificationsListRequested extends NotificationsEvent {
  String token;

  NotificationsListRequested({required this.token});

  @override
  List<Object> get props => [token];
}

class NotificationsDetailsRequested extends NotificationsEvent {
  final String token;
  final int notificationId;

  NotificationsDetailsRequested({required this.token, required this.notificationId});

  @override
  List<Object> get props => [token, notificationId];
}


class NotificationsListDeleteRequested extends NotificationsEvent {
  final String token;
  final String id;

  NotificationsListDeleteRequested({required this.token, required this.id});

  @override
  List<Object> get props => [token, id];
}

part of 'notifications_bloc.dart';

abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object> get props => [];
}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsLoadSuccess extends NotificationsState {
  final Map<dynamic, dynamic> notifications;

  NotificationsLoadSuccess({required this.notifications});

  @override
  List<Object> get props => [notifications];
}

class NotificationsLoadFailure extends NotificationsState {}


class NotificationsDetailsLoadProgress extends NotificationsState{}


class NotificationsDetailsLoadSuccess extends NotificationsState{

  final Map<dynamic, dynamic> notification;

  const NotificationsDetailsLoadSuccess({required this.notification});

  @override
  List<Object> get props=> [notification];
}

class NotificationsDetailsLoadFailure extends NotificationsState{}

class NotificationsDeleteLoadProgress extends NotificationsState{}


class NotificationsDeleteLoadSuccess extends NotificationsState{

  final bool status ;

  const NotificationsDeleteLoadSuccess({required this.status});

  @override
  List<Object> get props=> [status];

}

class NotificationsDeleteLoadFailure extends NotificationsState{}
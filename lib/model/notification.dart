import 'package:bestcannedfood_ecommerce/model/noti.dart';
import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Notifications extends Equatable {
  String? id;
  Noti? notification;
  String? readAt;
  int? orderId;

  Notifications({this.id, this.notification, this.readAt, this.orderId});

  @override
  List<Object?> get props => [id, notification, readAt, orderId];

  static Notifications fromNotificationsList(dynamic jsonData) {
    Map<dynamic, dynamic> noti = jsonData['notification'];
    return Notifications(
        id: jsonData['id'].toString(),
        notification: Noti.fromNotiList(noti),
        readAt: jsonData['read_at'],
        orderId: noti['data']);
  }
}

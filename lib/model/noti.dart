import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Noti extends Equatable {
  String? title;
  String? subtitle;
  String? type;
  // Bodys? body;
  int? data;
  String? time;

  Noti({
    this.title,
    this.subtitle,
    this.type,
    // this.body,
    this.data,
    this.time,
  });

  static Noti fromNotiList(dynamic jsonData) {
    //Map<dynamic, dynamic> body = jsonData['body'];
    return Noti(
      title: jsonData['title'],
      subtitle: jsonData['subtitle'],
      type: jsonData['type'],
      // body: Bodys.fromBodyList(body),
      data: jsonData['data'],
      time: jsonData['time'],
    );
  }

  @override
  List<Object?> get props => [
        title,
        subtitle,
        type,
        // body,
        data,
        time,
      ];
}

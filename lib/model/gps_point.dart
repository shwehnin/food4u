import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class GpsPoint extends Equatable {
  double? latitude;
  double? longitude;

  GpsPoint({this.latitude, this.longitude});

  static GpsPoint fromGpsPoint(dynamic jsonData) {
    return GpsPoint(
        latitude: jsonData['latitude'], longitude: jsonData['longitude']);
  }

  @override
  List<Object?> get props => [latitude ?? '', longitude ?? ''];
}

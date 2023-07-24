import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int? id;
  final String customerName;
  final String email;
  final String deliveryLocation;
  final String phoneVerified;
  final String fcmToken;
  final int deliAreasId;
  final String phone;
  final String? token;

  User(
      {this.id,
      required this.customerName,
      required this.email,
      required this.deliveryLocation,
      required this.phoneVerified,
      required this.fcmToken,
      required this.deliAreasId,
      required this.phone,
      this.token});

  @override
  List<Object> get props => [
        id!,
        customerName,
        email,
        deliveryLocation,
        phoneVerified,
        fcmToken,
        deliAreasId,
        phone,
        token!
      ];

  static User fromJson(dynamic json) {
    return User(
        id: -1,
        customerName: json['data']['customer_name'],
        email: json['data']['email'] != null ? json['data']['email'] : '',
        deliveryLocation: json['data']['delivery_location'],
        phoneVerified: json['data']['phone_verified'],
        fcmToken:
            json['data']['fcm_token'] != null ? json['data']['fcm_token'] : '',
        deliAreasId: json['data']['deli_areas_id'],
        phone: json['data']['phone'].toString(),
        token: json['access_token'] != null ? json['access_token'] : '');
  }

  static User fromSharePreJson(dynamic json) {
    return User(
        id: -1,
        customerName: json['customer_name'],
        email: json['email'],
        deliveryLocation: json['delivery_location'],
        phoneVerified: json['phone_verified'],
        fcmToken: json['fcm_token'],
        deliAreasId: json['deli_areas_id'],
        phone: json['phone'],
        token: json['access_token']);
  }

  static User fromUserForProfile(dynamic json) {
    return User(
        id: json['id'] == null ? -1 : json['id'],
        customerName: json['customer_name'],
        email: json['email'] != null ? json['email'] : '',
        deliveryLocation: json['delivery_location'],
        phoneVerified: json['phone_verified'],
        fcmToken: json['fcm_token'],
        deliAreasId: json['deli_limited_area'] != null
            ? json['deli_limited_area']['id']
            : 1,
        phone: json['phone'],
        token: json['access_token'] != null ? json['access_token'] : '');
  }

  static User fromUserForMyOrder(dynamic json) {
    return User(
        id: int.parse(json['id'].toString()),
        phone: json['phone'].toString(),
        customerName: '',
        deliAreasId: -1,
        deliveryLocation: '',
        email: '',
        fcmToken: '',
        phoneVerified: '',
        token: '');
  }

  Map<String, dynamic> toJson() => {
        "customer_name": customerName,
        "email": email,
        "delivery_location": deliveryLocation,
        "phone_verified": phoneVerified,
        "fcm_token": fcmToken,
        "deli_areas_id": deliAreasId,
        "phone": phone,
        "access_token": token
      };
}

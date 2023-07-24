import 'package:bestcannedfood_ecommerce/model/gps_point.dart';
import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Company extends Equatable {
  String? id;
  String? logo;
  String? companyName;
  String? companyAddress;
  String? companyPhone;
  String? standardCurrency;
  int? tax;
  List<GpsPoint>? gpsPoint;

  Company(
      {this.id,
      this.logo,
      this.companyName,
      this.companyAddress,
      this.companyPhone,
      this.standardCurrency,
      this.tax,
      this.gpsPoint});

  static Company fromCompanyList(dynamic jsonData) {
    return Company(
        id: jsonData['id'].toString(),
        logo: jsonData['logo'],
        companyName: jsonData['company_name'],
        companyAddress: jsonData['company_address'],
        companyPhone: jsonData['company_phone'].toString(),
        standardCurrency: jsonData['stan_currency'],
        tax: jsonData['tax'],
        gpsPoint: jsonData['gps_point'] != null
            ? List<GpsPoint>.from(
                    jsonData['gps_point'].map((i) => GpsPoint.fromGpsPoint(i)))
                .toList()
            : null);
  }

  @override
  List<Object?> get props => [
        id ?? '',
        logo ?? '',
        companyName ?? '',
        companyAddress ?? '',
        companyPhone ?? '',
        standardCurrency ?? '',
        tax ?? '',
        gpsPoint ?? '',
      ];
}

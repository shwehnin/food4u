import 'package:equatable/equatable.dart';

class PaymentTypes extends Equatable {
  final int id;
  final String? accountName;
  final String? accountNumber;
  final String? bankName;
  final String? paymentType;
  final String? status;

  PaymentTypes({
    required this.id,
    this.accountName,
    this.accountNumber,
    this.bankName,
    this.paymentType,
    this.status
  });

  @override
  List<Object> get props => [
        id,
        accountName!,
        accountNumber!,
        bankName!,
        paymentType!,
        status!
      ];

  static PaymentTypes fromJson(dynamic json) {
    return PaymentTypes(
      id: json['id'],
      accountName: json['account_name'] != null ? json['account_name']: '',
      accountNumber: json['account_number'] != null ? json['account_number'].toString(): '',
      bankName: json['bank_name'] != null ? json['bank_name']: '',
      paymentType: json['payment_type'],
      status: json['status'] !=null ? json['status']: '',
    );
  }
}

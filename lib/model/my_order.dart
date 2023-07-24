import 'dart:convert';

import 'package:bestcannedfood_ecommerce/model/models.dart';
import 'package:equatable/equatable.dart';

class MyOrder extends Equatable {
  final int id;
  final String status;
  final String salesOrderDate;
  final String preferredDate;
  final String preferredTime;
  final String deliveryNote;
  final String customerName;
  final String deliveryLocation;
  final int taxAmount;
  final int discountAmount;
  final int salesCustId;
  final String salesOrderAutoinc;
  final int grandTotal;
  final int deliveryFee;
  final int subTotal;
  final String canceledMsg;
  final String township;
  final String myanmarRegion;
  final String cancelEvidenceFile;
  final User customer;
  final PaymentTypes payment;
  final List<FoodMaster> salesDetail;
  final List<dynamic> statusTimeLine;
  final String receiptEvidenceFile;

  MyOrder(
      {required this.id,
      required this.status,
      required this.salesOrderDate,
      required this.preferredDate,
      required this.preferredTime,
      required this.deliveryNote,
      required this.customerName,
      required this.deliveryLocation,
      required this.taxAmount,
      required this.discountAmount,
      required this.salesCustId,
      required this.salesOrderAutoinc,
      required this.grandTotal,
      required this.deliveryFee,
      required this.subTotal,
      required this.canceledMsg,
      required this.township,
      required this.myanmarRegion,
      required this.cancelEvidenceFile,
      required this.customer,
      required this.payment,
      required this.salesDetail,
      required this.statusTimeLine,
      required this.receiptEvidenceFile});

  @override
  List<Object> get props => [
        id,
        status,
        salesOrderDate,
        preferredDate,
        preferredTime,
        deliveryNote,
        customerName,
        deliveryLocation,
        taxAmount,
        discountAmount,
        salesCustId,
        salesOrderAutoinc,
        grandTotal,
        deliveryFee,
        subTotal,
        canceledMsg,
        township,
        myanmarRegion,
        cancelEvidenceFile,
        customer,
        payment,
        salesDetail,
        statusTimeLine,
        receiptEvidenceFile
      ];

  static MyOrder fromMyOrdersList(dynamic jsonData) {
    return MyOrder(
        id: jsonData['id'],
        status: jsonData['status'],
        salesOrderDate: jsonData['sales_order_date'],
        preferredDate: jsonData['preferred_date'],
        preferredTime: jsonData['preferred_time'],
        deliveryNote: jsonData['delivery_note'],
        customerName: jsonData['customer_name'],
        deliveryLocation: jsonData['delivery_location'],
        taxAmount: jsonData['tax_amount'],
        discountAmount: jsonData['discount_amount'],
        salesCustId: jsonData['sales_cust_id'],
        salesOrderAutoinc: jsonData['sales_order_autoinc'],
        grandTotal: jsonData['grand_total'],
        deliveryFee:
            jsonData['delivery_fee'] != null ? jsonData['delivery_fee'] : 0.0,
        subTotal: jsonData['sub_total'],
        canceledMsg: jsonData['canceled_msg'],
        township: jsonData['township'],
        myanmarRegion: jsonData['myanmar_region'],
        cancelEvidenceFile: jsonData['cancel_evidence_file'],
        customer: User.fromUserForMyOrder(jsonData['customer']),
        payment: PaymentTypes.fromJson(jsonData['payment']),
        salesDetail: List<FoodMaster>.from(jsonData['sales_detail']
            .map((i) => FoodMaster.fromFoodMasterList(i))),
        statusTimeLine: json.decode(jsonData['status_timeline']),
        receiptEvidenceFile: jsonData['receipt_evidence_file'] != null
            ? jsonData['receipt_evidence_file']
            : '');
  }
}

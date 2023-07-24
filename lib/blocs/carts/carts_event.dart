part of 'carts_bloc.dart';

abstract class CartsEvent extends Equatable {
  const CartsEvent();

  @override
  List<Object> get props => [];
}

class InitialCartRequested extends CartsEvent {
  @override
  List<Object> get props => [];
}

class CartListRequested extends CartsEvent {
  final String token;

  CartListRequested({required this.token});

  @override
  List<Object> get props => [token];
}

class CartUpdateRequested extends CartsEvent {
  final String token;
  final int cartItemId;
  final int orderQty;

  CartUpdateRequested(
      {required this.token, required this.cartItemId, required this.orderQty});

  @override
  List<Object> get props => [token, cartItemId, orderQty];
}

class CartDeleteRequested extends CartsEvent {
  final String token;
  final int cartItemId;

  CartDeleteRequested({required this.token, required this.cartItemId});
  @override
  List<Object> get props => [token, cartItemId];
}

class VoucherVerifyRequested extends CartsEvent {
  final String token;
  final String voucher;

  VoucherVerifyRequested({
    required this.token,
    required this.voucher,
  });

  @override
  List<Object> get props => [token, voucher];
}

class CreateCheckoutRequsted extends CartsEvent {
  final String token;
  final String voucher;
  final String preferredDate;
  final String preferredTime;
  final String deliveryNote;
  final int paymentType;
  final String receiptEvidenceFile;
  final double grandTotal;

  CreateCheckoutRequsted(
      {required this.token,
      required this.voucher,
      required this.preferredDate,
      required this.preferredTime,
      required this.deliveryNote,
      required this.paymentType,
      required this.receiptEvidenceFile,
      required this.grandTotal});

  @override
  List<Object> get props => [
        token,
        voucher,
        preferredDate,
        preferredTime,
        deliveryNote,
        paymentType,
        receiptEvidenceFile,
        grandTotal
      ];
}

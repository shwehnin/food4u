part of 'payment_types_bloc.dart';

abstract class PaymentTypesEvent extends Equatable {
  const PaymentTypesEvent();
}

class PaymentTypesListRequested extends PaymentTypesEvent {
  final String? token;

  PaymentTypesListRequested({this.token,})
      : assert(token != null);
  @override
  List<Object?> get props => [
    token,
  ];
}

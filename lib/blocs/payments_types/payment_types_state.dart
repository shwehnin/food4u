part of 'payment_types_bloc.dart';

abstract class PaymentTypesState extends Equatable {
  const PaymentTypesState();

  @override
  List<Object> get props => [];
}

class PaymentTypesInitialState extends PaymentTypesState {}

class PaymentTypesLoadingState extends PaymentTypesState {}

class PaymentTypesLoadingSuccessState extends PaymentTypesState {
  final List<PaymentTypes> paymentTypes;

  const PaymentTypesLoadingSuccessState({required this.paymentTypes});

  @override
  List<Object> get props => [paymentTypes];
}

class PaymentTypesFailureState extends PaymentTypesState {}

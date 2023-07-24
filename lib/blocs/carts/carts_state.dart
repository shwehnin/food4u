part of 'carts_bloc.dart';

abstract class CartsState extends Equatable {
  const CartsState();

  @override
  List<Object> get props => [];
}

class CartsInitialState extends CartsState {}

class CartLoadingSuccessState extends CartsState {
  final Map<dynamic, dynamic> carts;

  const CartLoadingSuccessState({required this.carts});

  @override
  List<Object> get props => [carts];
}

class CartFailureState extends CartsState {
  final Object message;
  const CartFailureState({required this.message});

  @override
  List<Object> get props => [message];
}

class CartUpdateLoadingState extends CartsState {}

class CartUpdateLoadingSuccess extends CartsState {
  final Map<dynamic, dynamic> data;
  CartUpdateLoadingSuccess({required this.data});

  @override
  List<Object> get props => [data];
}

class CartUpdateFailure extends CartsState {}

class CartDeleteLoadingState extends CartsState {}

class CartDeleteLoadingSuccess extends CartsState {
  final Map<dynamic, dynamic> data;

  CartDeleteLoadingSuccess({required this.data});
  @override
  List<Object> get props => [data];
}

class CartDeleteFailure extends CartsState {}


class VoucherVerifyLoadInProgress extends CartsState {}

class VoucherVerifyLoadSuccess extends CartsState {
  final Map<dynamic, dynamic> data;
  const VoucherVerifyLoadSuccess({required this.data});
  @override
  List<Object> get props => [data];
}

class VoucherVerifyLoadFailure extends CartsState {
  final Object message;
  const VoucherVerifyLoadFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class CreateCheckoutLoadInProgress extends CartsState {}

class CreateCheckoutLoadSuccess extends CartsState {
  final Map<dynamic, dynamic> data;
  const CreateCheckoutLoadSuccess({required this.data});
  @override
  List<Object> get props => [data];
}

class CreateCheckoutLoadFailure extends CartsState {
  final Object message;
  const CreateCheckoutLoadFailure({required this.message});

  @override
  List<Object> get props => [message];
}

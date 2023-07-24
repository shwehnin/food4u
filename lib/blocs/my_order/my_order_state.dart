part of 'my_order_bloc.dart';

@immutable
abstract class MyOrdersState {
  const MyOrdersState();
  List<Object> get props => [];
}

class InitialMyOrdersListState extends MyOrdersState {}

class MyOrdersListLoadInProgress extends MyOrdersState {}

class MyOrdersListLoadSuccess extends MyOrdersState {
  final Map<dynamic, dynamic> myOrdersList;
  const MyOrdersListLoadSuccess({required this.myOrdersList});
  @override
  List<Object> get props => [myOrdersList];
}

class MyOrdersListLoadFailure extends MyOrdersState {
  final Object message;
  const MyOrdersListLoadFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class OrderDetailState extends MyOrdersState {}

class OrderDetailLoadInProgress extends MyOrdersState {}

class OrderDetailLoadSuccess extends MyOrdersState {
  final MyOrder myOrder;
  const OrderDetailLoadSuccess({required this.myOrder});
  @override
  List<Object> get props => [myOrder];
}

class OrderDetailLoadFailure extends MyOrdersState {}

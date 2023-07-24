part of 'my_order_bloc.dart';

@immutable
abstract class MyOrdersListEvent extends Equatable {
  const MyOrdersListEvent();
}

//Initial Order requested
class InitialOrdersRequested extends MyOrdersListEvent {
  @override
  List<Object?> get props => [];
}

// My Orders List Request
class MyOrdersListRequested extends MyOrdersListEvent {
  final String token;
  final String status;
  final String duration;
  final String sort;
  final String order;
  final int paginate;
  final int page;
  final bool isFirstTime;

  MyOrdersListRequested(
      {required this.token,
      required this.status,
      required this.duration,
      required this.sort,
      required this.order,
      required this.paginate,
      required this.page,
      required this.isFirstTime});

  @override
  List<Object> get props =>
      [token, status, duration, sort, order, paginate, page, isFirstTime];
}

// Order Detail Request
class OrderDetailRequested extends MyOrdersListEvent {
  final String token;
  final int id;
  final bool isFirstTime;

  OrderDetailRequested(
      {required this.token, required this.id, required this.isFirstTime});

  @override
  List<Object> get props => [token, id, isFirstTime];
}

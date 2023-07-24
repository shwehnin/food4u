part of 'voucher_bloc.dart';

@immutable
abstract class VoucherEvent extends Equatable {
  const VoucherEvent();
}

class VoucherListRequested extends VoucherEvent {
  final String token;
  final String keyword;
  final String sort;
  final String order;
  final int paginate;
  final int page;
  final bool isFirstTime;

  VoucherListRequested(
      {required this.token,
      required this.keyword,
      required this.sort,
      required this.order,
      required this.paginate,
      required this.page,
      required this.isFirstTime});

  @override
  List<Object> get props =>
      [token, keyword, sort, order, paginate, page, isFirstTime];
}



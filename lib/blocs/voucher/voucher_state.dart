part of 'voucher_bloc.dart';

@immutable
abstract class VoucherState {
  const VoucherState();
  List<Object> get props => [];
}

class InitialVoucherListState extends VoucherState {}

class VoucherListLoadInProgress extends VoucherState {}

class VoucherListLoadSuccess extends VoucherState {
  final Map<dynamic, dynamic> voucherList;
  const VoucherListLoadSuccess({required this.voucherList});
  @override
  List<Object> get props => [voucherList];
}

class VoucherListLoadFailure extends VoucherState {}



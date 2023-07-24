import 'dart:async';
import 'package:bestcannedfood_ecommerce/data/repositories/ecommerce_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'voucher_event.dart';
part 'voucher_state.dart';

class VoucherBloc extends Bloc<VoucherEvent, VoucherState> {
  final EcommerceRepository ecommerceRepository;

  VoucherBloc({required this.ecommerceRepository})
      : super(InitialVoucherListState());

  @override
  Stream<VoucherState> mapEventToState(VoucherEvent event) async* {
    // Get Voucher List
    if (event is VoucherListRequested) {
      yield* _mapVoucherListRequestedToState(event);
    }
  }

  // Get Voucher List
  Stream<VoucherState> _mapVoucherListRequestedToState(
    VoucherListRequested event,
  ) async* {
    if (event.isFirstTime) {
      yield VoucherListLoadInProgress();
    }

    try {
      final Map<dynamic, dynamic> voucherList =
          await ecommerceRepository.getVoucherList(
              event.token, event.sort, event.order, event.paginate, event.page);
      yield VoucherListLoadSuccess(voucherList: voucherList);
    } catch (_) {
      yield VoucherListLoadFailure();
    }
  }
}

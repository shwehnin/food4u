import 'dart:async';

import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/data/repositories/ecommerce_repository.dart';
import 'package:bestcannedfood_ecommerce/translations/locale_keys.g.dart';
import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

part 'carts_event.dart';
part 'carts_state.dart';

class CartsBloc extends Bloc<CartsEvent, CartsState> {
  final EcommerceRepository ecommerceRepository;

  CartsBloc({required this.ecommerceRepository}) : super(CartsInitialState());
  @override
  Stream<CartsState> mapEventToState(
    CartsEvent event,
  ) async* {
    if (event is InitialCartRequested) {
      yield* _mapInitialCartRequestedToState(event);
    }
    if (event is CartListRequested) {
      yield* _mapCartListRequestedToState(event);
    }
    if (event is CartUpdateRequested) {
      yield* _mapCartUpdateRequestedToState(event);
    }
    if (event is CartDeleteRequested) {
      yield* _mapCartDeleteRequested(event);
    }
    if (event is VoucherVerifyRequested) {
      yield* _mapVoucherVerifyRequestedToState(event);
    }
    if (event is CreateCheckoutRequsted) {
      yield* _mapCreateCheckoutRequestedToState(event);
    }
  }

  Stream<CartsState> _mapCartListRequestedToState(
    CartListRequested event,
  ) async* {
    try {
      final Map<dynamic, dynamic> carts =
          await ecommerceRepository.getCarts(event.token);
      yield CartLoadingSuccessState(carts: carts);
    } catch (error) {
      yield CartFailureState(message: error);
    }
  }

  Stream<CartsState> _mapCartUpdateRequestedToState(
      CartUpdateRequested event) async* {
    try {
      final Map<dynamic, dynamic> data = await ecommerceRepository.updateCart(
          event.token, event.cartItemId, event.orderQty);
      showSuccessMessage(LocaleKeys.updated_cart.tr());
      yield CartUpdateLoadingSuccess(data: data);
    } catch (_) {
      yield CartUpdateFailure();
    }
  }

  Stream<CartsState> _mapCartDeleteRequested(CartDeleteRequested event) async* {
    yield CartDeleteLoadingState();
    try {
      final Map<dynamic, dynamic> data =
          await ecommerceRepository.deleteCart(event.token, event.cartItemId);
      showSuccessMessage(LocaleKeys.deleted_cart.tr());
      final Map<dynamic, dynamic> carts =
          await ecommerceRepository.getCarts(event.token);
      yield CartLoadingSuccessState(carts: carts);
    } catch (_) {
      yield CartDeleteFailure();
    }
  }

  // Get Voucher Verify
  Stream<CartsState> _mapVoucherVerifyRequestedToState(
    VoucherVerifyRequested event,
  ) async* {
    yield VoucherVerifyLoadInProgress();

    try {
      final Map<dynamic, dynamic> data = await ecommerceRepository
          .getVoucherVerify(event.token, event.voucher);
      yield VoucherVerifyLoadSuccess(data: data);
    } catch (error) {
      var data = error.toString().replaceAll('Exception: ', '');

      String message = data;
      print('VoucherVerifyLoadFailure $message');

      EasyLoading.showError(message, duration: Duration(seconds: 5));
      final Map<dynamic, dynamic> carts =
          await ecommerceRepository.getCarts(event.token);
      yield CartLoadingSuccessState(carts: carts);
    }
  }

  // Create checkout
  Stream<CartsState> _mapCreateCheckoutRequestedToState(
    CreateCheckoutRequsted event,
  ) async* {
    yield CreateCheckoutLoadInProgress();

    try {
      final Map<dynamic, dynamic> data =
          await ecommerceRepository.getCreateCheckOut(
              event.token,
              event.voucher,
              event.preferredDate,
              event.preferredTime,
              event.deliveryNote,
              event.paymentType,
              event.receiptEvidenceFile,
              event.grandTotal);
      yield CreateCheckoutLoadSuccess(data: data);
      print('cart data $data');
    } catch (error) {
      yield CreateCheckoutLoadFailure(message: error);
      print('cart error $error');
    }
  }

  Stream<CartsState> _mapInitialCartRequestedToState(
      InitialCartRequested event) async* {
    yield CartsInitialState();
  }
}

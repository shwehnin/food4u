import 'dart:async';

import 'package:bestcannedfood_ecommerce/data/repositories/ecommerce_repository.dart';
import 'package:bestcannedfood_ecommerce/model/models.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'payment_types_event.dart';
part 'payment_types_state.dart';

class PaymentTypesBloc extends Bloc<PaymentTypesEvent, PaymentTypesState> {
  final EcommerceRepository ecommerceRepository;
  PaymentTypesBloc({required this.ecommerceRepository})
      : super(PaymentTypesInitialState());

  @override
  Stream<PaymentTypesState> mapEventToState(
    PaymentTypesEvent event,
  ) async* {
    if (event is PaymentTypesListRequested) {
      yield* _mapCompanyListRequestedState(event);
    }
  }

  Stream<PaymentTypesState> _mapCompanyListRequestedState(
      PaymentTypesListRequested event) async* {
    yield PaymentTypesLoadingState();

    try {
      final List<PaymentTypes> _paymentTypes =
          await ecommerceRepository.getPaymentList(event.token!);
      yield PaymentTypesLoadingSuccessState(paymentTypes: _paymentTypes);
    } catch (_) {
      yield PaymentTypesFailureState();
    }
  }
}

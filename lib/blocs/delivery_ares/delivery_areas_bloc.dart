import 'dart:async';
import 'package:bestcannedfood_ecommerce/data/repositories/ecommerce_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'delivery_areas_event.dart';
part 'delivery_areas_state.dart';

class DeliveryBloc extends Bloc<DeliveryEvent, DeliveryState> {
  final EcommerceRepository ecommerceRepository;

  DeliveryBloc({required this.ecommerceRepository})
      : super(InitialDeliveryState());

  @override
  Stream<DeliveryState> mapEventToState(DeliveryEvent event) async* {
    //Delivery Area
    if (event is DeliveryAreaIdRequested) {
      yield* _mapUserDeliveryAreaIdRequestedToState(event);
    }
  }

  //Delivery
  Stream<DeliveryState> _mapUserDeliveryAreaIdRequestedToState(
    DeliveryAreaIdRequested event,
  ) async* {
    yield DeliveryAreaIdLoadInProgress();

    try {
      final List<dynamic> list = await ecommerceRepository.getDeliveryAreaIds(
          event.keyword, event.sort, event.order);
      yield DeliveryAreaIdLoadSuccess(areasList: list);
    } catch (_) {
      yield DeliveryAreaIdLoadFailure();
    }
  }
}

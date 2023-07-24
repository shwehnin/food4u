import 'dart:async';
import 'package:bestcannedfood_ecommerce/data/repositories/ecommerce_repository.dart';
import 'package:bestcannedfood_ecommerce/model/my_order.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'my_order_event.dart';
part 'my_order_state.dart';

class MyOrdersBloc extends Bloc<MyOrdersListEvent, MyOrdersState> {
  final EcommerceRepository ecommerceRepository;

  MyOrdersBloc({required this.ecommerceRepository})
      : super(InitialMyOrdersListState());

  @override
  Stream<MyOrdersState> mapEventToState(MyOrdersListEvent event) async* {
    //Initial Order requested
    if (event is InitialOrdersRequested) {
      yield* _mapInitialOrdersRequestedToState(event);
    }
    // Get My Orders List
    if (event is MyOrdersListRequested) {
      yield* _mapMyOrdersListRequestedToState(event);
    }

    // Get Order Detail
    if (event is OrderDetailRequested) {
      yield* _mapOrderDetailRequestedToState(event);
    }
  }

  // Get My Orders List
  Stream<MyOrdersState> _mapMyOrdersListRequestedToState(
    MyOrdersListRequested event,
  ) async* {
    if (event.isFirstTime) {
      yield MyOrdersListLoadInProgress();
    }

    try {
      final Map<dynamic, dynamic> myOrdersList =
          await ecommerceRepository.getAllMyOrdersList(event.token, event.sort,
              event.order, event.paginate, event.page, event.status);
      yield MyOrdersListLoadSuccess(myOrdersList: myOrdersList);
    } catch (error) {
      yield MyOrdersListLoadFailure(message: error);
    }
  }

  // Get Order Detail
  Stream<MyOrdersState> _mapOrderDetailRequestedToState(
    OrderDetailRequested event,
  ) async* {
    if (event.isFirstTime) {
      yield OrderDetailLoadInProgress();
    }

    final MyOrder myOrder =
        await ecommerceRepository.getOrderDetail(event.token, event.id);
    yield OrderDetailLoadSuccess(myOrder: myOrder);
  }

  Stream<MyOrdersState> _mapInitialOrdersRequestedToState(
      InitialOrdersRequested event) async* {
    yield InitialMyOrdersListState();
  }
}

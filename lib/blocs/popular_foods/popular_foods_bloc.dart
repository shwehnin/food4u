import 'dart:async';
import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/data/repositories/ecommerce_repository.dart';
import 'package:bestcannedfood_ecommerce/model/food_master.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'popular_foods_event.dart';
part 'popular_foods_state.dart';

class PopularFoodsBloc extends Bloc<PopularFoodsEvent, PopularFoodsState> {
  final EcommerceRepository ecommerceRepository;

  PopularFoodsBloc({required this.ecommerceRepository})
      : super(InitialPopularFoodsListState());

  @override
  Stream<PopularFoodsState> mapEventToState(PopularFoodsEvent event) async* {
    if (event is InitialPopularFoodsRequested) {
      yield* _mapInitialFoodsRequestedToState(event);
    }
    //Foods Limit List
    if (event is PopularFoodsLimitListRequested) {
      yield* _mapFoodsLimitListRequestedToState(event);
    }

    if (event is PopularFavouriteCreateRequested) {
      yield* _mapPopularFavouriteCreateRequestedToState(event);
    }
  }

  Stream<PopularFoodsState> _mapInitialFoodsRequestedToState(
      InitialPopularFoodsRequested event) async* {
    yield InitialPopularFoodsListState();
  }

  // Foods Limit List
  Stream<PopularFoodsState> _mapFoodsLimitListRequestedToState(
    PopularFoodsLimitListRequested event,
  ) async* {
    yield PopularFoodsListLoadInProgress();

    try {
      final List<FoodMaster> _foodsList =
          await ecommerceRepository.getFoodsLimitList(event.limit, event.token);

      yield PopularFoodsListLoadSuccess(foodsList: _foodsList);
    } catch (_) {
      yield PopularFoodsListLoadFailure();
    }
  }

  Stream<PopularFoodsState> _mapPopularFavouriteCreateRequestedToState(
      PopularFavouriteCreateRequested event) async* {
    try {
      final String message = await ecommerceRepository.createFavouriteFood(
          event.token, event.foodId);
      showFavouriteSnackbar(message, event.context, event.token);

      final List<FoodMaster> _foodsList = await ecommerceRepository
          .getFoodsLimitList(popularFoodsLimit, event.token);

      yield PopularFoodsListLoadSuccess(foodsList: _foodsList);
    } catch (_) {
      yield PopularFoodsListLoadFailure();
    }
  }
}

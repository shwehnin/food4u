import 'dart:async';
import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/data/repositories/ecommerce_repository.dart';
import 'package:bestcannedfood_ecommerce/model/food_master.dart';
import 'package:bestcannedfood_ecommerce/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'foods_event.dart';
part 'foods_state.dart';

class FoodsBloc extends Bloc<FoodsEvent, FoodsState> {
  final EcommerceRepository ecommerceRepository;

  FoodsBloc({required this.ecommerceRepository})
      : super(InitialFoodsListState());

  @override
  Stream<FoodsState> mapEventToState(FoodsEvent event) async* {
    // Foods List
    if (event is InitialFoodsRequested) {
      yield* _mapInitialFoodsRequestedToState(event);
    }
    if (event is FoodsListRequested) {
      yield* _mapFoodsListRequestedToState(event);
    }

    if (event is LatestFoodsListRequested) {
      yield* _mapLatestFoodsListRequestedToState(event);
    }

    if (event is FoodsDetailRequested) {
      yield* _mapFoodsDetailRequestedToState(event);
    }

    if (event is FoodsAddToCartRequested) {
      yield* _mapFoodsAddToCartRequestedToState(event);
    }

    if (event is FoodFavouriteCreateRequested) {
      yield* _mapFoodFavouriteCreateRequestedToState(event);
    }
  }

  // Foods List
  Stream<FoodsState> _mapFoodsListRequestedToState(
    FoodsListRequested event,
  ) async* {
    if (event.isFirstTime) {
      yield FoodsListLoadInProgress();
    }

    try {
      final Map<dynamic, dynamic> _foodsList =
          await ecommerceRepository.getFoodsList(
              event.category,
              event.subCategory,
              event.size,
              event.spicyLevel,
              event.minPrice,
              event.maxPrice,
              event.keyword,
              event.order,
              event.paginate,
              event.page,
              event.token,
              event.sort);
      yield FoodsListLoadSuccess(foodsList: _foodsList);
    } catch (_) {
      yield FoodsListLoadFailure();
    }
  }

  Stream<FoodsState> _mapFoodsDetailRequestedToState(
    FoodsDetailRequested event,
  ) async* {
    yield FoodsDetailsListLoadInProgress();

    try {
      final FoodMaster foodMaster =
          await ecommerceRepository.getFoodsDetails(event.id);

      yield FoodsDetailListLoadSuccess(foodMaster: foodMaster);
    } catch (_) {
      yield FoodsDetailsListLoadFailure();
    }
  }

  Stream<FoodsState> _mapLatestFoodsListRequestedToState(
    LatestFoodsListRequested event,
  ) async* {
    //yield LatestFoodsListLoadInProgress();

    try {
      final List<FoodMaster> _foodsList =
          await ecommerceRepository.getFoodsLimitList(event.limit, event.token);

      yield LatestFoodsListLoadSuccess(foodsList: _foodsList);
    } catch (_) {
      yield FoodsListLoadFailure();
    }
  }

  Stream<FoodsState> _mapFoodsAddToCartRequestedToState(
    FoodsAddToCartRequested event,
  ) async* {
    //yield FoodAddToCartLoadProgress();

    try {
      final String message = await ecommerceRepository.getAddToCart(
        event.foodId,
        event.orderQty,
        event.size,
        event.spicy,
        event.choiceOfA,
        event.choiceOfB,
        event.choiceOfC,
        event.choiceOfD,
        event.addOnA,
        event.addOnB,
        event.addOnC,
        event.addOnD,
        event.addOnE,
        event.token,
        event.itemColor,
      );
      //Add to cart successfully
      showSnacknar(LocaleKeys.successfully_added_to_your.tr(), event.context,
          event.token);
      //yield FoodAddToCartLoadSuccess(message: message);
    } catch (error) {
      var data = error.toString().replaceAll('Exception: ', '');
      showErrorMessage(data.toString());
    }
  }

  Stream<FoodsState> _mapInitialFoodsRequestedToState(FoodsEvent event) async* {
    yield InitialFoodsListState();
  }

  Stream<FoodsState> _mapFoodFavouriteCreateRequestedToState(
      FoodFavouriteCreateRequested event) async* {
    try {
      final String message = await ecommerceRepository.createFavouriteFood(
        event.token,
        event.foodId,
      );

      if (event.type == "home") {
        BlocProvider.of<FoodsBloc>(event.context)
          ..add(LatestFoodsListRequested(
            limit: latestFoodsLimit,
            token: event.token,
          ));
        showFavouriteSnackbar(message, event.context, event.token);
      } else if (event.type == "detail") {
        final FoodMaster foodMaster =
            await ecommerceRepository.getFoodsDetails(event.foodId.toString());

        yield FoodsDetailListLoadSuccess(foodMaster: foodMaster);
        showFavouriteSnackbar(message, event.context, event.token);
      } else {
        yield FoodAddToFavouriteLoadSuccess(message: message);
      }
    } catch (_) {
      yield FoodsDetailsListLoadFailure();
    }
  }
}

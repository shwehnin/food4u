import 'package:bestcannedfood_ecommerce/blocs/favourites/favourites_event.dart';
import 'package:bestcannedfood_ecommerce/blocs/favourites/favourites_state.dart';
import 'package:bestcannedfood_ecommerce/config/constants.dart';
import 'package:bestcannedfood_ecommerce/data/repositories/ecommerce_repository.dart';
import 'package:bestcannedfood_ecommerce/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavouritesBloc extends Bloc<FavouritesEvent, FavouritesState> {
  final EcommerceRepository ecommerceRepository;

  FavouritesBloc({required this.ecommerceRepository})
      : super(FavouritesInitialState());

  @override
  Stream<FavouritesState> mapEventToState(FavouritesEvent event) async* {
    if (event is InitialFavouriteRequested) {
      yield* _mapInitialFavouriteRequestedToState(event);
    }

    if (event is FavouritesListRequested) {
      yield* _mapFavouritesListRequestedToState(event);
    }

    if (event is FavouriteItemCreateRequested) {
      yield* _mapFavouriteItemCreateRequestedToState(event);
    }
    if (event is FavouriteItemRemoveRequested) {
      yield* _mapFavouriteItemRemoveRequestedToState(event);
    }
  }

  Stream<FavouritesState> _mapInitialFavouriteRequestedToState(
      InitialFavouriteRequested event) async* {
    yield FavouritesInitialState();
  }

  Stream<FavouritesState> _mapFavouritesListRequestedToState(
    FavouritesListRequested event,
  ) async* {
    if (event.isFirstTime!) yield FavouritesLoadingState();

    try {
      final Map<dynamic, dynamic> favourites =
          await ecommerceRepository.getFavouriteList(
        event.keyword!,
        event.sort!,
        event.order!,
        event.paginate!,
        event.page!,
        event.token!,
      );

      yield FavouritesLoadingSuccessState(favourites: favourites);
    } catch (error) {
      yield FavouritesFailureState(message: error);
    }
  }

  Stream<FavouritesState> _mapFavouriteItemCreateRequestedToState(
      FavouriteItemCreateRequested event) async* {
    try {
      final String message = await ecommerceRepository.createFavouriteFood(
          event.token, event.foodId);

      //Favourite create
      showToast(LocaleKeys.added_to_favourites.tr());

      yield FavouriteCreateSuccessState(message: '$message,${event.foodId}');
    } catch (_) {
      yield FavouriteCreateFailureState();
    }
  }

  Stream<FavouritesState> _mapFavouriteItemRemoveRequestedToState(
      FavouriteItemRemoveRequested event) async* {
    try {
      final String message = await ecommerceRepository.createFavouriteFood(
          event.token, event.foodId);

      yield FavouriteRemoveSuccessState(message: message);
    } catch (_) {
      yield FavouriteCreateFailureState();
    }
  }
}

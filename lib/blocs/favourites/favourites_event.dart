import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class FavouritesEvent extends Equatable {
  const FavouritesEvent();
}


class InitialFavouriteRequested extends FavouritesEvent{
  @override
  List<Object?> get props => [];
}


class FavouritesListRequested extends FavouritesEvent {
  final String? keyword;
  final String? sort;
  final String? order;
  final int? paginate;
  final int? page;
  final String? token;
  final bool? isFirstTime;

  FavouritesListRequested(
      {this.keyword,
      this.sort,
      this.order,
      this.paginate,
      this.page,
      this.token,
      this.isFirstTime});

  @override
  List<Object?> get props =>
      [keyword, sort, order, paginate, page, token, isFirstTime];
}

class FavouriteItemCreateRequested extends FavouritesEvent {
  final String token;
  final int foodId;

  FavouriteItemCreateRequested({required this.token, required this.foodId});

  @override
  List<Object?> get props => [token, foodId];
}

class FavouriteItemRemoveRequested extends FavouritesEvent {
  final String token;
  final int foodId;
  final String? keyword;
  final String? sort;
  final String? order;
  final int? paginate;
  final int? page;

  FavouriteItemRemoveRequested({
    required this.token,
    required this.foodId,
    this.keyword,
    this.sort,
    this.order,
    this.paginate,
    this.page,
  });

  @override
  List<Object?> get props => [
        token,
        foodId,
        keyword,
        sort,
        order,
        paginate,
        page,
      ];
}

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class FavouritesState extends Equatable {
  const FavouritesState();

  List<Object> get props => [];
}

class FavouritesInitialState extends FavouritesState {}

class FavouritesLoadingState extends FavouritesState {}

class FavouritesLoadingSuccessState extends FavouritesState {
  final Map<dynamic, dynamic> favourites;

  const FavouritesLoadingSuccessState({required this.favourites});

  @override
  List<Object> get props => [favourites];
}

class FavouritesFailureState extends FavouritesState {
  final Object message;
  const FavouritesFailureState({required this.message});

  @override
  List<Object> get props => [message];
}


class FavouriteCreateLoadingState extends FavouritesState {}

class FavouriteCreateSuccessState extends FavouritesState {
  final String message;

  const FavouriteCreateSuccessState({required this.message});

  @override
  List<Object> get props => [message];
}

class FavouriteCreateFailureState extends FavouritesState {}


class FavouriteRemoveLoadingState extends FavouritesState {}

class FavouriteRemoveSuccessState extends FavouritesState {
  final String message;

  const FavouriteRemoveSuccessState({required this.message});

  @override
  List<Object> get props => [message];
}

class FavouriteRemoveFailureState extends FavouritesState {}

part of 'foods_bloc.dart';

@immutable
abstract class FoodsState {
  const FoodsState();
  List<Object> get props => [];
}

class InitialFoodsListState extends FoodsState {}

// Foods List page states Start
class FoodsListLoadInProgress extends FoodsState {}

class FoodsListLoadSuccess extends FoodsState {
  final Map<dynamic, dynamic> foodsList;

  const FoodsListLoadSuccess({required this.foodsList});

  @override
  List<Object> get props => [foodsList];
}

class FoodsListLoadFailure extends FoodsState {}


//Foods Limit List latest foods
class LatestFoodsListLoadInProgress extends FoodsState {}

class LatestFoodsListLoadSuccess extends FoodsState {
  final List<FoodMaster>foodsList;

  const LatestFoodsListLoadSuccess({required this.foodsList});

  @override
  List<Object> get props => [foodsList];
}

class LatestFoodsListLoadFailure extends FoodsState {}

//Food details 
class FoodsDetailsListLoadInProgress extends FoodsState {}

class FoodsDetailListLoadSuccess extends FoodsState {
  final FoodMaster foodMaster;

  const FoodsDetailListLoadSuccess({required this.foodMaster});

  @override
  List<Object> get props => [foodMaster];
}

class FoodsDetailsListLoadFailure extends FoodsState {}


//Food add to cart
class FoodAddToCartLoadProgress extends FoodsState{}

class FoodAddToCartLoadSuccess extends FoodsState{
  final String message;

  const FoodAddToCartLoadSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class FoodAddToCartLoadFailure extends FoodsState {
  final Object message;
  const FoodAddToCartLoadFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class FoodAddToFavouriteLoadProgress extends FoodsState{}

class FoodAddToFavouriteLoadSuccess extends FoodsState{
  final String message;

  const FoodAddToFavouriteLoadSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class FoodAddToFavouriteLoadFailure extends FoodsState {
  final Object message;
  const FoodAddToFavouriteLoadFailure({required this.message});

  @override
  List<Object> get props => [message];
}


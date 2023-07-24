part of 'popular_foods_bloc.dart';

@immutable
abstract class PopularFoodsState {
  const PopularFoodsState();
  List<Object> get props => [];
}


class InitialPopularFoodsListState extends PopularFoodsState {}

// Foods List page states Start
class PopularFoodsListLoadInProgress extends PopularFoodsState {}

class PopularFoodsListLoadSuccess extends PopularFoodsState {
  final List<FoodMaster>foodsList;

  const PopularFoodsListLoadSuccess({required this.foodsList});

  @override
  List<Object> get props => [foodsList];
}

class PopularFoodsListLoadFailure extends PopularFoodsState {}


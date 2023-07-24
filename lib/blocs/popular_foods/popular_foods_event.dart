part of 'popular_foods_bloc.dart';

@immutable
abstract class PopularFoodsEvent extends Equatable {
  const PopularFoodsEvent();
}

class InitialPopularFoodsRequested extends PopularFoodsEvent {
  @override
  List<Object?> get props => [];
}

class PopularFoodsLimitListRequested extends PopularFoodsEvent {
  final int limit;
  final String token;

  PopularFoodsLimitListRequested({
    required this.limit,
    required this.token
  });

  @override
  List<Object> get props => [
    limit, token];
}

class PopularFavouriteCreateRequested extends PopularFoodsEvent {
  final String token;
  final int foodId;
  final BuildContext context;

  PopularFavouriteCreateRequested({required this.token, required this.foodId, required this.context});

  @override
  List<Object?> get props => [token, foodId, context];
}

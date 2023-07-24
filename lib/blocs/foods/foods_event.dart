part of 'foods_bloc.dart';

@immutable
abstract class FoodsEvent extends Equatable {
  const FoodsEvent();
}

class InitialFoodsRequested extends FoodsEvent {
  @override
  List<Object?> get props => [];
}

class FoodsListRequested extends FoodsEvent {
  final String category;
  final String subCategory;
  final String size;
  final String spicyLevel;
  final String minPrice;
  final String maxPrice;
  final String keyword;
  final String order;
  final int paginate;
  final int page;
  final bool isFirstTime;
  final String token;
  final String sort;

  FoodsListRequested(
      {required this.category,
      required this.subCategory,
      required this.size,
      required this.spicyLevel,
      required this.minPrice,
      required this.maxPrice,
      required this.keyword,
      required this.order,
      required this.paginate,
      required this.page,
      required this.isFirstTime,
      required this.token,
      required this.sort});

  @override
  List<Object> get props => [
        category,
        subCategory,
        size,
        spicyLevel,
        minPrice,
        maxPrice,
        keyword,
        order,
        // paginate,
        page,
        isFirstTime,
        token,
        sort
      ];
}

class LatestFoodsListRequested extends FoodsEvent {
  final int limit;
  final String token;
  LatestFoodsListRequested({required this.limit, required this.token});

  @override
  List<Object> get props => [limit, token];
}

class FoodsDetailRequested extends FoodsEvent {
  final String id;

  FoodsDetailRequested({
    required this.id,
  });

  @override
  List<Object> get props => [id];
}

class FoodsAddToCartRequested extends FoodsEvent {
  final int foodId;
  final int orderQty;
  final String size;
  final String spicy;
  final bool choiceOfA;
  final bool choiceOfB;
  final bool choiceOfC;
  final bool choiceOfD;
  final bool addOnA;
  final bool addOnB;
  final bool addOnC;
  final bool addOnD;
  final bool addOnE;
  final String token;
  final BuildContext context;
  final String itemColor;

  FoodsAddToCartRequested({
    required this.foodId,
    required this.orderQty,
    required this.size,
    required this.spicy,
    required this.choiceOfA,
    required this.choiceOfB,
    required this.choiceOfC,
    required this.choiceOfD,
    required this.addOnA,
    required this.addOnB,
    required this.addOnC,
    required this.addOnD,
    required this.addOnE,
    required this.token,
    required this.context,
    required this.itemColor,
  });

  @override
  List<Object?> get props => [
        foodId,
        orderQty,
        size,
        spicy,
        choiceOfA,
        choiceOfB,
        choiceOfC,
        choiceOfD,
        addOnA,
        addOnB,
        addOnC,
        context,
        itemColor
      ];
}

class FoodFavouriteCreateRequested extends FoodsEvent {
  final String token;
  final int foodId;
  final String slug;
  final String type;
  final BuildContext context;

  FoodFavouriteCreateRequested(
      {required this.token,
      required this.foodId,
      required this.slug,
      required this.type,
      required this.context});

  @override
  List<Object?> get props => [token, foodId, slug, type, context];
}

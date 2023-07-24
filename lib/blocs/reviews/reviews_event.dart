part of 'reviews_bloc.dart';

@immutable
abstract class ReviewsEvent extends Equatable {
  const ReviewsEvent();
}

class ReviewsListRequested extends ReviewsEvent {
  final String sort;
  final String order;
  final int paginate;
  final int page;
  final int foodId;
  final String token;

  ReviewsListRequested(
      {required this.sort,
      required this.order,
      required this.paginate,
      required this.page,
      required this.foodId,
      required this.token});

  @override
  List<Object> get props => [sort, order, paginate, page, foodId, token];
}

class ReviewsCreatedRequested extends ReviewsEvent {
  final String message;
  final double rating;
  final int foodId;
  final String foodName;
  final String token;

  ReviewsCreatedRequested(
      {required this.message,
      required this.rating,
      required this.foodId,
      required this.foodName,
      required this.token});
  @override
  List<Object> get props => [message, rating, foodId, foodName, token];
}

class ReviewsDeletedRequested extends ReviewsEvent {
  final int reviewId;
  final String token;
  final String sort;
  final String order;
  final int paginate;
  final int page;
  final int foodId;

  ReviewsDeletedRequested({
    required this.reviewId,
    required this.token,
    required this.sort,
    required this.order,
    required this.paginate,
    required this.page,
    required this.foodId,
  });

  @override
  List<Object> get props =>
      [sort, order, paginate, page, foodId, reviewId, token];
}

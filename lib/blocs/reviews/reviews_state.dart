part of 'reviews_bloc.dart';

@immutable
abstract class ReviewsState {
  const ReviewsState();
  List<Object> get props => [];
}

class InitialPopularFoodsListState extends ReviewsState {}


//Reviews List page states Start
class ReviewsListLoadInProgress extends ReviewsState {}

class ReviewsListLoadSuccess extends ReviewsState {
  final List<Reviews> data;

  const ReviewsListLoadSuccess({required this.data});

  @override
  List<Object> get props => [data];
}

class ReviewsListLoadFailure extends ReviewsState {}

//Review Created

class ReviewsCreatedLoadInProgress extends ReviewsState {}

class ReviewsCreatedLoadSuccess extends ReviewsState {
  final String message;

  const ReviewsCreatedLoadSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class ReviewsCreatedLoadFailure extends ReviewsState{
  final Object message;
  const ReviewsCreatedLoadFailure({required this.message});

  @override
  List<Object> get props => [message];
}


//Reviews Deleted

class ReviewsDeletedLoadInProgress extends ReviewsState {}

class ReviewsDeletedLoadSuccess extends ReviewsState {
  final String message;

  const ReviewsDeletedLoadSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class ReviewsDeletedLoadFailure extends ReviewsState {}


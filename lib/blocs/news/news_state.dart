part of 'news_bloc.dart';

@immutable
abstract class NewsState {
  const NewsState();
  List<Object> get props => [];
}

class InitialNewsListState extends NewsState {}

// News List page states Start
class NewsListLoadInProgress extends NewsState {}

class NewsListLoadSuccess extends NewsState {
  final Map<dynamic, dynamic> newsList;

  const NewsListLoadSuccess({required this.newsList});

  @override
  List<Object> get props => [newsList];
}

class NewsListLoadFailure extends NewsState {}

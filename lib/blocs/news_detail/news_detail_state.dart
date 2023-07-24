part of 'news_detail_bloc.dart';

@immutable
abstract class NewsDetailState {
  const NewsDetailState();
  List<Object> get props => [];
}

class InitialNewsDetailState extends NewsDetailState {}

class NewsDetailLoadInProgress extends NewsDetailState {}

class NewsDetailLoadSuccess extends NewsDetailState {
  final News newsDetail;
  const NewsDetailLoadSuccess({required this.newsDetail});
  @override
  List<Object> get props => [newsDetail];
}

class NewsDetailLoadFailure extends NewsDetailState {}

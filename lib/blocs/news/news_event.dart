part of 'news_bloc.dart';

@immutable
abstract class NewsEvent extends Equatable {
  const NewsEvent();
}

class NewsListRequested extends NewsEvent {
  final String keyword;
  final String sort;
  final String order;
  final int paginate;
  final int page;
  final bool isFirstTime;

  NewsListRequested(
      {required this.keyword,
      required this.sort,
      required this.order,
      required this.paginate,
      required this.page,
      required this.isFirstTime});

  @override
  List<Object> get props => [keyword, sort, order, paginate, page, isFirstTime];
}

part of 'news_detail_bloc.dart';

@immutable
abstract class NewsDetailEvent extends Equatable {
  const NewsDetailEvent();
}

class NewsDetailRequested extends NewsDetailEvent {
  final String slug;
  NewsDetailRequested({
    required this.slug,
  });

  @override
  List<Object> get props => [slug];
}

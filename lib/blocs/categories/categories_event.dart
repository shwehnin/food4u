part of 'categories_bloc.dart';

@immutable
abstract class CategoriesEvent extends Equatable {
  const CategoriesEvent();
}

class CategoriesListRequested extends CategoriesEvent {
  final String keyword;
  final String sort;
  final String order;

  CategoriesListRequested(
      {
      required this.keyword,
      required this.sort,
      required this.order,});

  @override
  List<Object> get props =>
      [keyword, sort, order];
}

part of 'sub_categories_bloc.dart';

abstract class SubCategoriesEvent extends Equatable {
  const SubCategoriesEvent();
}

class SubCategoriesListRequested extends SubCategoriesEvent {
  final int categoryId;
  final String category;
  final String sort;
  final String order;

  SubCategoriesListRequested({
    required this.categoryId,
    required this.category,
    required this.sort,
    required this.order,
  });

  @override
  List<Object> get props => [categoryId, sort, order];
}

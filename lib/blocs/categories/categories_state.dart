part of 'categories_bloc.dart';

@immutable
abstract class CategoriesState {
  const CategoriesState();
  List<Object> get props => [];
}

class InitialVoucherListState extends CategoriesState {}

class CategoriesListLoadInProgress extends CategoriesState {}

class CategoriesListLoadSuccess extends CategoriesState {
  final List<Category> categoriesList;

  const CategoriesListLoadSuccess({required this.categoriesList});

  @override
  List<Object> get props => [categoriesList];
}

class CategoriesListLoadFailure extends CategoriesState {}

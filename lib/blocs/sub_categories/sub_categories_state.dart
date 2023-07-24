part of 'sub_categories_bloc.dart';

abstract class SubCategoriesState extends Equatable {
  const SubCategoriesState();

  @override
  List<Object> get props => [];
}

class SubCategoriesListLoadInProgress extends SubCategoriesState {}

class SubCategoriesListLoadSuccess extends SubCategoriesState {
  final List<SubCategory> subCategoriesList;

  const SubCategoriesListLoadSuccess({required this.subCategoriesList});

  @override
  List<Object> get props => [subCategoriesList];
}

class SubCategoriesListLoadFailure extends SubCategoriesState {}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:bestcannedfood_ecommerce/data/repositories/ecommerce_repository.dart';
import 'package:bestcannedfood_ecommerce/model/sub_category.dart';

part 'sub_categories_event.dart';
part 'sub_categories_state.dart';

class SubCategoriesBloc extends Bloc<SubCategoriesEvent, SubCategoriesState> {
  final EcommerceRepository ecommerceRepository;
  SubCategoriesBloc({required this.ecommerceRepository})
      : super(SubCategoriesListLoadInProgress());

  @override
  Stream<SubCategoriesState> mapEventToState(SubCategoriesEvent event) async* {
    // SubCategories List
    if (event is SubCategoriesListRequested) {
      yield* _mapSubCategoriesListRequestedToState(event);
    }
  }

  // Get Categories List
  Stream<SubCategoriesState> _mapSubCategoriesListRequestedToState(
    SubCategoriesListRequested event,
  ) async* {
    yield SubCategoriesListLoadInProgress();

    try {
      final List<SubCategory> _subCategoriesList =
          await ecommerceRepository.getSubCategoriesList(
              event.categoryId, event.category, event.sort, event.order);
      yield SubCategoriesListLoadSuccess(subCategoriesList: _subCategoriesList);
    } catch (_) {
      yield SubCategoriesListLoadFailure();
    }
  }
}

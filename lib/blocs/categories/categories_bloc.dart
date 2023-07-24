import 'dart:async';
import 'package:bestcannedfood_ecommerce/data/repositories/ecommerce_repository.dart';
import 'package:bestcannedfood_ecommerce/model/category.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'categories_event.dart';
part 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final EcommerceRepository ecommerceRepository;

  CategoriesBloc({required this.ecommerceRepository})
      : super(InitialVoucherListState());

  @override
  Stream<CategoriesState> mapEventToState(CategoriesEvent event) async* {
    // Get Categories List
    if (event is CategoriesListRequested) {
      yield* _mapVoucherListRequestedToState(event);
    }
  }

  // Get Categories List
  Stream<CategoriesState> _mapVoucherListRequestedToState(
    CategoriesListRequested event,
  ) async* {
    yield CategoriesListLoadInProgress();

    try {
      final List<Category> _categoriesList = await ecommerceRepository
          .getCategoriesList(event.keyword, event.sort, event.order);
      yield CategoriesListLoadSuccess(categoriesList: _categoriesList);
    } catch (_) {
      yield CategoriesListLoadFailure();
    }
  }
}

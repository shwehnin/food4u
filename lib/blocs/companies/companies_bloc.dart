import 'dart:async';

import 'package:bestcannedfood_ecommerce/data/repositories/ecommerce_repository.dart';
import 'package:bestcannedfood_ecommerce/model/company.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'companies_event.dart';
part 'companies_state.dart';

class CompaniesBloc extends Bloc<CompaniesEvent, CompaniesState> {
  final EcommerceRepository ecommerceRepository;
  CompaniesBloc({required this.ecommerceRepository})
      : super(CompaniesInitialState());

  @override
  Stream<CompaniesState> mapEventToState(
    CompaniesEvent event,
  ) async* {
    if (event is CompanyListRequested) {
      yield* _mapCompanyListRequestedState(event);
    }
  }

  Stream<CompaniesState> _mapCompanyListRequestedState(
      CompanyListRequested event) async* {
    yield CompaniesLoadingState();
    final List<Company> companies = await ecommerceRepository.getCompaniesList(
        event.keyword!, event.sort!, event.order!);
    yield CompaniesLoadingSuccessState(companies: companies);

    try {} catch (_) {
      yield CompaniesFailureState();
    }

    // yield CompaniesFailureState();
  }
}

part of 'companies_bloc.dart';

abstract class CompaniesState extends Equatable {
  const CompaniesState();

  @override
  List<Object> get props => [];
}

class CompaniesInitialState extends CompaniesState {}

class CompaniesLoadingState extends CompaniesState {}

class CompaniesLoadingSuccessState extends CompaniesState {
  final List<Company> companies;

  const CompaniesLoadingSuccessState({required this.companies});

  @override
  List<Object> get props => [companies];
}

class CompaniesFailureState extends CompaniesState {}

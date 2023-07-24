part of 'companies_bloc.dart';

abstract class CompaniesEvent extends Equatable {
  const CompaniesEvent();
}

class CompanyListRequested extends CompaniesEvent {
  final String? keyword;
  final String? sort;
  final String? order;

  CompanyListRequested({this.keyword, this.sort, this.order})
      : assert(keyword != null),
        assert(sort != null),
        assert(order != null);

  @override
  List<Object?> get props => [
        keyword,
        sort,
        order,
      ];
}

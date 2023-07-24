part of 'delivery_areas_bloc.dart';

@immutable
abstract class DeliveryEvent extends Equatable {
  const DeliveryEvent();
}

class InitialDeliveryLoginRequested extends DeliveryEvent {

  InitialDeliveryLoginRequested();

  @override
  List<Object> get props => [];
}


class DeliveryAreaIdRequested extends DeliveryEvent {

  final String keyword;
  final String sort;
  final String order;

  DeliveryAreaIdRequested(
      {required this.keyword,
      required this.sort,
      required this.order,});

  @override
  List<Object> get props => [
        keyword,
        sort,
        order,
      ];
}

part of 'delivery_areas_bloc.dart';

@immutable
abstract class DeliveryState {
  const DeliveryState();
  List<Object> get props => [];
}

class InitialDeliveryState extends DeliveryState {}

class DeliveryAreaIdLoadInProgress extends DeliveryState {}

class DeliveryAreaIdLoadSuccess extends DeliveryState {
  final List<dynamic> areasList;
  const DeliveryAreaIdLoadSuccess({required this.areasList});

  @override
  List<Object> get props => [areasList];
}

class DeliveryAreaIdLoadFailure extends DeliveryState{}

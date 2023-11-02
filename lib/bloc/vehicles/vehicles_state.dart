part of 'vehicles_bloc.dart';

@immutable
class VehiclesState {}

class VehiclesInitial extends VehiclesState {}

class VehicleLoadingState extends VehiclesState {}

class VehicleLoadedState extends VehiclesState {
  final String ownerId;
  VehicleLoadedState({required this.ownerId});
}

class VehicleViewDetailsState extends VehiclesState {
  final Vehicle vehicle;
  VehicleViewDetailsState({required this.vehicle});
}

class VehicleAddingState extends VehiclesState {}

class VehicleUpdateSuccess extends VehiclesState {}

class VehicleAddSuccess extends VehiclesState {}

class VehicleErrorState extends VehiclesState {
  final String message;
  VehicleErrorState({required this.message});
}

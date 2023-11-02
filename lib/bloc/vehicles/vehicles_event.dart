part of 'vehicles_bloc.dart';

@immutable
class VehiclesEvent {}

class LoadMyVehicles extends VehiclesEvent {
  final String id;
  LoadMyVehicles({required this.id});
}

class AddVehicle extends VehiclesEvent {
  final List<XFile> images;
  final Vehicle vehicle;
  AddVehicle({required this.images, required this.vehicle});
}

class UpdateVehicle extends VehiclesEvent {
  final List<XFile> images;
  final Vehicle vehicle;
  UpdateVehicle({required this.images, required this.vehicle});
}

class ViewVehicleDetails extends VehiclesEvent {
  final Vehicle vehicle;
  ViewVehicleDetails({required this.vehicle});
}

class ShowLoading extends VehiclesEvent {}

class ShowAddVehicleForm extends VehiclesEvent {}

import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:vehicle_reporting/model/vehicle.dart';
import 'package:vehicle_reporting/services.dart/vehicle_services.dart';

part 'vehicles_event.dart';
part 'vehicles_state.dart';

class VehiclesBloc extends Bloc<VehiclesEvent, VehiclesState> {
  VehiclesBloc() : super(VehiclesInitial()) {
    on<LoadMyVehicles>((event, emit) {
      emit(VehicleLoadedState(ownerId: event.id));
    });
    on<ShowAddVehicleForm>((event, emit) {
      emit(VehicleAddingState());
    });
    on<ViewVehicleDetails>((event, emit) {
      emit(VehicleViewDetailsState(vehicle: event.vehicle));
    });
    on<ShowLoading>((event, emit) {
      emit(VehicleLoadingState());
    });
    on<UpdateVehicle>((event, emit) async {
      try {
        emit(VehicleLoadingState());
        await VehicleServices.instance
            .update(vehicle: event.vehicle, images: event.images);
        emit(VehicleUpdateSuccess());
      } catch (e) {
        emit(VehicleErrorState(message: e.toString()));
      }
    });
    on<AddVehicle>((event, emit) async {
      emit(VehicleLoadingState());
      try {
        await VehicleServices.instance
            .addVehicle(vehicle: event.vehicle, images: event.images);
        emit(VehicleAddSuccess());
      } catch (e) {
        emit(VehicleErrorState(message: e.toString()));
      }
    });
  }
}

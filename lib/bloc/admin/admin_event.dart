part of 'admin_bloc.dart';

@immutable
abstract class AdminEvent {
  const AdminEvent();
}

class LoadLogin extends AdminEvent {}

class LoadLogs extends AdminEvent {}

class ViewRegisteredVehicle extends AdminEvent {}

class ViewRegisteredVehicleDetaiils extends AdminEvent {
  final Vehicle vehicle;
  const ViewRegisteredVehicleDetaiils({required this.vehicle});
}

class UpdateRegisterVehicleApproval extends AdminEvent {
  final Vehicle vehicle;
  const UpdateRegisterVehicleApproval({required this.vehicle});
}

class ShowAddUserScreen extends AdminEvent {}

class AddUser extends AdminEvent {
  final String plateNumber;
  final String ownerName;
  final String contact;
  final String affiliation;
  const AddUser(
      {required this.affiliation,
      required this.contact,
      required this.ownerName,
      required this.plateNumber});
}

class LoginAdmin extends AdminEvent {
  final String username;
  final String password;
  final String type;
  const LoginAdmin(
      {required this.password, required this.type, required this.username});
}

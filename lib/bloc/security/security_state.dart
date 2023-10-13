part of 'security_bloc.dart';

@immutable
abstract class SecurityState {
  const SecurityState();
}

class SecurityInitial extends SecurityState {}

class ReportedVehiclesLoaded extends SecurityState{
  
}
class SecurityLoadingScreen extends SecurityState{

}
class SecurityErrorState extends SecurityState{
final String message;
const SecurityErrorState({required this.message});
}
class SecurityLoginPageLoaded extends SecurityState{
  final bool? success;
  const SecurityLoginPageLoaded({this.success});

}

class LogPosted extends SecurityState{
  final VehicleLogs vehicleLogs;
  const LogPosted({required this.vehicleLogs});
}
class OCRScannerLoaded extends SecurityState{
  
}
class SecurityLoggedInState extends SecurityState{
  final bool success;
  const SecurityLoggedInState({required this.success});
}


part of 'security_bloc.dart';

@immutable
abstract class SecurityEvent {
  const SecurityEvent();
}

class GetReportedVehicles extends SecurityEvent{

}
class LoadLoginPage extends SecurityEvent{

}
class ScanVehicle extends SecurityEvent{
  final String path;
 const ScanVehicle({required this.path});
}
class PostLogs extends SecurityEvent{
  final String plate;
  const PostLogs({required this.plate});
}
class LoginSecurity extends SecurityEvent{
  final String username;
  final String password;
  final String type;
  const LoginSecurity({required this.username, required this.password, required this.type});
}

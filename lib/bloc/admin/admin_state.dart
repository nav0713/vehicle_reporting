part of 'admin_bloc.dart';

@immutable
abstract class AdminState {
  const AdminState();
}

class AdminInitial extends AdminState {}
class AdminErrorState extends AdminState{
  final String message;
  const AdminErrorState({required this.message});
}
class AdminLoadingState extends AdminState{
  
}

class AddUserFormLoaded extends AdminState{

}

class OwnderAdded extends AdminState{

}

class LogsLoaded extends AdminState{
  
}


class AdminLoggedInState extends AdminState{
  final bool success;
  const AdminLoggedInState({required this.success});

}
class AdminLoginPageLoaded extends AdminState{
  final bool success;
  const AdminLoginPageLoaded({ required this.success});

}

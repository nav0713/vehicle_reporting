import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:vehicle_reporting/services.dart/admin_services.dart';

part 'admin_event.dart';
part 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  AdminBloc() : super(AdminInitial()) {
    on<LoadLogin>((event, emit) {
     emit(const AdminLoginPageLoaded(success: true));
    });on<LoginAdmin>((event,emit)async{
  try{
        emit(AdminLoadingState());
        bool success = await AdminServices.instance.adminLogin(username: event.username, password: event.password, type: event.type);
        if(success){
          emit(AdminLoggedInState(success: success));
        }else{
          
          emit(AdminLoginPageLoaded(success: success));
   
        }
      }catch(e){
        emit(AdminErrorState(message: e.toString()));
      }
    }); on<LoadLogs>((event,emit){
      emit(LogsLoaded());
    });
    on<ShowAddUserScreen>((event,emit){
      emit(AddUserFormLoaded());
    });on<AddUser>((event,emit)async{
      emit(AdminLoadingState());
      try{
        AdminServices.instance.addUser(name: event.ownerName, affilation: event.affiliation, contact: event.contact, plate: event.plateNumber);
        emit(OwnderAdded());
      }catch(e){
        emit(AdminErrorState(message: e.toString()));
      }
    });
  }
}

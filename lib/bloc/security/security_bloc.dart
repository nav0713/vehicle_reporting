import 'package:bloc/bloc.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:meta/meta.dart';
import 'package:vehicle_reporting/model/logs.dart';
import 'package:vehicle_reporting/services.dart/security_services.dart';
import 'package:fluttertoast/fluttertoast.dart';
part 'security_event.dart';
part 'security_state.dart';

class SecurityBloc extends Bloc<SecurityEvent, SecurityState> {
  SecurityBloc() : super(SecurityInitial()) {
    on<LoadLoginPage>((event, emit) {
      emit(const SecurityLoginPageLoaded(success: true));
    });
    on<LoginSecurity>((event,emit)async{
      try{
        emit(SecurityLoadingScreen());
        bool success = await SecurityServices.instance.securityLogin(username: event.username, password: event.password, type: event.type);
        if(success){
          emit(SecurityLoggedInState(success: success));
        }else{
          
          emit(SecurityLoginPageLoaded(success: success));
   
        }
      }catch(e){
        emit(SecurityErrorState(message: e.toString()));
      }
    });
    on<GetReportedVehicles>((event,emit){
      emit(ReportedVehiclesLoaded());
    });
    on<ScanVehicle>((event,emit)async{
      emit(SecurityLoadingScreen());
   try{
 String plate = "";
   final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
   final InputImage img = InputImage.fromFilePath(event.path);
   final RecognizedText text = await recognizer.processImage(img);
   if(text.blocks.length == 1){
    plate = text.blocks.first.text;
   }else if(text.blocks.length <= 2){
    plate = text.blocks[1].text;
   }
     VehicleLogs log = await SecurityServices.instance.postLogs(plate: plate);
      emit(LogPosted(vehicleLogs: log));
   }catch(e){
    emit(SecurityErrorState(message: e.toString()));
   }
    });
  }
}

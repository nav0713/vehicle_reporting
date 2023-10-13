// ignore: depend_on_referenced_packages
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:vehicle_reporting/services.dart/student_services.dart';

part 'student_event.dart';
part 'student_state.dart';
class StudentBloc extends Bloc<StudentEvent, StudentState> {
  StudentBloc() : super(StudentInitial()) {
        on<GetPlateNumber>((event, emit) async{
   emit(ReportLoadingState());
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
emit(ReportingState(plateNumber: plate));
   }catch(e){
    emit(ReportErrorState(message: e.toString()));
   }
    });
    on<ReportVehicle>((event, emit) async {
      emit(ReportLoadingState());
      try {
        String url = await StudentServices.instance.getDownLoadUrl(file: event.imageFile);
        await StudentServices.instance.reportVehicle(
          url: url,
          plateNumber: event.plateNumber,
          studentId: event.studentIdNumber,
        );
        emit(ReportSuccess());
      } catch (e) {
        emit(ReportErrorState(message: e.toString()));
      }
    });
  }
}

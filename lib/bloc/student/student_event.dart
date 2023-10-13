part of 'student_bloc.dart';

@immutable
abstract class StudentEvent {}

class GetPlateNumber extends StudentEvent{
  final String path;
   GetPlateNumber({required this.path});
}
class ViewReportForm extends StudentEvent{
  final String plateNumber;
   ViewReportForm({required this.plateNumber});
}
class ReportVehicle extends StudentEvent{
  final String plateNumber;
  final String studentIdNumber;
  final XFile imageFile;
   ReportVehicle({ required this.studentIdNumber, required this.imageFile, required this.plateNumber});

}

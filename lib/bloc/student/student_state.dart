part of 'student_bloc.dart';

@immutable
abstract class StudentState {}

class StudentInitial extends StudentState {}

class OCRstate extends StudentState{

}
class ReportingState extends StudentState{
  final String plateNumber;
   ReportingState({required this.plateNumber});
}
class ReportSuccess extends StudentState{

}
class ReportLoadingState extends StudentState{

}
class ReportErrorState extends StudentState{
  final String message;
  ReportErrorState({required this.message});
}

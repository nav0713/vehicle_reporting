import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vehicle_reporting/bloc/student/student_bloc.dart';

class OCR extends StatefulWidget {
  const OCR({super.key});

  @override
  State<OCR> createState() => _OCRState();
}

class _OCRState extends State<OCR> {
  @override
  Widget build(BuildContext context) {
    return Container();
    // return  ScalableOCR(
    //               paintboxCustom: Paint()
    //                 ..style = PaintingStyle.stroke
    //                 ..strokeWidth = 4.0
    //                 ..color = const Color.fromARGB(153, 102, 160, 241),
    //               boxLeftOff: 10,
    //               boxBottomOff: 10,
    //               boxRightOff: 10,
    //               boxTopOff: 10,
    //               boxHeight: MediaQuery.of(context).size.height * .50,
    //               getRawData: (value) {
             
    //                 //  print("the value is"+ value.toString());
    //               },
    //               getScannedText: (value) {
    //           if(value.toString().isNotEmpty){
    //          context.read<StudentBloc>().add(ViewReportForm(plateNumber: value.toString()));
    //           }
                 
    //               });
  }
}
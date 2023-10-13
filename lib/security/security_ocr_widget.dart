import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vehicle_reporting/bloc/security/security_bloc.dart';
import 'package:vehicle_reporting/bloc/student/student_bloc.dart';

class SecurityOCR extends StatefulWidget {
  const SecurityOCR({super.key});

  @override
  State<SecurityOCR> createState() => _SecurityOCRState();
}

class _SecurityOCRState extends State<SecurityOCR> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SecurityBloc, SecurityState>(
        listener: (context, state) {
          BuildContext parent= context;
          if(state is LogPosted){
            showDialog(context: context, builder: (BuildContext context){
              return AlertDialog(
                title: const Text("Log successfully saved"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Owner name: ${state.vehicleLogs.ownerName}"),
                    const SizedBox(height: 8,),
                    Text("Affiliation: ${state.vehicleLogs.affiliation}"),
                ]),
                actions: [
             
                     TextButton(onPressed: (){
                      Navigator.pop(context);
                           Navigator.pop(context);
                    parent.read<SecurityBloc>().add(GetReportedVehicles());
                  }, child: const Text("Ok")),
                ],
              );
            });
          }
        },
        builder: (context, state) {
          if(state is OCRScannerLoaded){
            return WillPopScope(
            onWillPop: () async {
              context.read<SecurityBloc>().add(GetReportedVehicles());
              return true;
            },
            child: Container(),
              // child: ScalableOCR(
              //     paintboxCustom: Paint()
              //       ..style = PaintingStyle.stroke
              //       ..strokeWidth = 4.0
              //       ..color = const Color.fromARGB(153, 102, 160, 241),
              //     boxLeftOff: 10,
              //     boxBottomOff: 10,
              //     boxRightOff: 10,
              //     boxTopOff: 10,
              //     boxHeight: MediaQuery.of(context).size.height * .50,
              //     getRawData: (value) {
              //       //  print("the value is"+ value.toString());
              //     },
              //     getScannedText: (value) {
              //       if (value.toString().isNotEmpty) {
              //          context.read<SecurityBloc>().add(PostLogs(plate: value.toString()));
              //       }
              //     }),
            
          );
          }if(state is SecurityLoadingScreen){
            return const  Center(child:  CircularProgressIndicator(color: Colors.white,));
          }
          return Container();
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vehicle_reporting/admin/admin_login.dart';
import 'package:vehicle_reporting/bloc/admin/admin_bloc.dart';
import 'package:vehicle_reporting/bloc/student/student_bloc.dart';
import 'package:vehicle_reporting/shared/home/header.dart';
import 'package:vehicle_reporting/shared/login_screen/security_login.dart';
import 'package:vehicle_reporting/student/student_screen.dart';
import '../../bloc/security/security_bloc.dart';
import '../../student/image_source_dialog.dart';
import '../../style.dart';
import '../../utils/cropper.dart';
import '../../utils/picker_image.dart';
import 'gradient_background.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Stack(
      children: [
        Header(
          deviceHeight: deviceHeight,
          deviceWidth: deviceWidth,
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: BackGroundGradient(
                deviceHeight: deviceHeight, deviceWidth: deviceWidth)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: deviceWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: deviceHeight * .45,
              ),
              Text(
                "Vehicle Identification Sytem using OCR Technology",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 30,
              ),
              ////Student
              SizedBox(
                height: 50,
                width: 200,
                child: ElevatedButton.icon(
                    style: mainBtnStyle(
                        Colors.red, Colors.transparent, Colors.white30),
                    onPressed: () {
                      imagePickerModal(
                          context: context,
                          cameraOnTap: () {
                            pickerImage(source: ImageSource.camera)
                                .then((value) {
                              if (value.isNotEmpty) {
                                imageCropperView(path: value, context: context)
                                    .then((newValue) {
                                  if (newValue.isNotEmpty) {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (BuildContext context) {
                                      return BlocProvider(
                                        create: (context) => StudentBloc()
                                          ..add(GetPlateNumber(path: newValue)),
                                        child: const StudentScreen(),
                                      );
                                    }));
                                  }
                                });
                              }
                            });
                          },
                          galleryOntap: () {
                            pickerImage(source: ImageSource.gallery)
                                .then((value) {
                              if (value.isNotEmpty) {
                                imageCropperView(path: value, context: context)
                                    .then((newValue) {
                                  if (newValue.isNotEmpty) {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (BuildContext context) {
                                      return BlocProvider(
                                        create: (context) => StudentBloc()
                                          ..add(GetPlateNumber(path: newValue)),
                                        child: const StudentScreen(),
                                      );
                                    }));
                                  }
                                });
                              }
                            });
                          });
                    
                    },
                    icon: const Icon(Icons.report),
                    label: const Text("Report Vehicle")),
              ),
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                height: 50,
                width: 200,
                child: ElevatedButton.icon(
                    style: mainBtnStyle(
                        Colors.deepOrange, Colors.transparent, Colors.white30),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return BlocProvider(
                            create: (context) =>
                                SecurityBloc()..add(LoadLoginPage()),
                            child: SecurityLoginScreen(
                                deviceHeight: deviceHeight,
                                deviceWidth: deviceWidth,
                                title: "Security Personnel Login",
                                type: "security"));
                      }));
                    },
                    icon: const Icon(Icons.security),
                    label: const Text("Security Personnel")),
              ),
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                height: 50,
                width: 200,
                child: ElevatedButton.icon(
                    style: mainBtnStyle(
                        Colors.indigo, Colors.transparent, Colors.white30),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return BlocProvider(
                            create: (context) => AdminBloc()..add(LoadLogin()),
                            child: AdminLoginScreen(
                                deviceHeight: deviceHeight,
                                deviceWidth: deviceWidth,
                                title: "Admin Personnel Login",
                                type: "Admin"));
                      }));
                    },
                    icon: const Icon(FontAwesome5.user_tie),
                    label: const Text("Administrator")),
              )
            ],
          ),
        )
      ],
    ));
  }
}

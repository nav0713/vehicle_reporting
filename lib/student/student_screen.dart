import 'dart:io';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:intl/intl.dart';
import 'package:vehicle_reporting/bloc/student/student_bloc.dart';
import 'package:vehicle_reporting/shared/home/home.dart';
import 'package:vehicle_reporting/student/ocr_widget.dart';
import 'package:vehicle_reporting/style.dart';
import 'package:vehicle_reporting/utils.dart';
import 'package:image_picker/image_picker.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key});

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

final formKey = GlobalKey<FormBuilderState>();
final idNumberController = TextEditingController();
XFile? file;
var img;

class _StudentScreenState extends State<StudentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Report Vehicle"),
        backgroundColor: Colors.black,
      ),
      body: BlocConsumer<StudentBloc, StudentState>(
        listener: (context, state) {
          if (state is ReportSuccess) {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.info),
                        const SizedBox(
                          height: 12,
                        ),
                        const Text("Report Success"),
                        const SizedBox(
                          height: 12,
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) {
                                return const HomePage();
                              }));
                            },
                            child: const Text("OK"))
                      ],
                    ),
                  );
                });
          }
        },
        builder: (context, state) {
          if (state is ReportingState) {
            return Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                padding:
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
                child: FormBuilder(
                  key: formKey,
                  child: Column(children: [
                    FormBuilderTextField(
                      validator: (value) {
                        if (value == null) {
                          return "This Field is required";
                        }
                        return null;
                      },
                      name: "platenumber",
                      enabled: false,
                      initialValue: state.plateNumber,
                      decoration: normalTextFieldStyle("Plate Number", ""),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Flexible(
                      child: FormBuilderTextField(
                        validator: (value) {
                          if (value == null) {
                            return "This Field is required";
                          }
                          return null;
                        },
                        enabled: false,
                        name: "datetime",
                        initialValue:
                            DateFormat.yMEd().add_jms().format(DateTime.now()),
                        decoration:
                            normalTextFieldStyle("date time", "date time"),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        Flexible(
                          flex: 12,
                          child: FormBuilderTextField(
                              validator: (value) {
                                if (value == null) {
                                  return "This Field is required";
                                }
                                return null;
                              },
                              controller: idNumberController,
                              enabled: false,
                              decoration: normalTextFieldStyle(
                                  "Student Id number", "id number"),
                              name: "id_number"),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Flexible(
                            child: IconButton(
                          icon: const Icon(FontAwesome5.qrcode),
                          onPressed: () async {
                            ScanResult qr =
                                await QRCodeBarCodeScanner.instance.scanner();
                            setState(() {
                              idNumberController.text =
                                  qr.rawContent.toString();
                            });
                          },
                        ))
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Center(
                        child: file == null
                            ? IconButton(
                                icon: const Icon(
                                  FontAwesome5.file_image,
                                  size: 100,
                                ),
                                onPressed: () async {
                                  ImagePicker picker = ImagePicker();
                                  XFile? newFile = await picker.pickImage(
                                      source: ImageSource.camera);
                                  if (newFile != null) {
                                    setState(() {
                                      file = newFile;
                                      img = Image.file(File(file!.path));
                                    });
                                  }
                                },
                              )
                            : Column(
                                children: [
                                  Image.file(
                                    File(file!.path),
                                    width: double.infinity,
                                    height: 250,
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          file = null;
                                        });
                                      },
                                      icon: const Icon(Icons.close))
                                ],
                              )),
                    const SizedBox(
                      height: 100,
                    ),
                    SizedBox(
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                          style: mainBtnStyle(
                              Colors.black, Colors.transparent, Colors.white10),
                          onPressed: () {
                            if (formKey.currentState!.saveAndValidate() &&
                                file != null) {
                              String plate =
                                  formKey.currentState?.value['platenumber'];
                              String id =
                                  formKey.currentState?.value['id_number'];
                              context.read<StudentBloc>().add(ReportVehicle(
                                  studentIdNumber: id,
                                  imageFile: file!,
                                  plateNumber: plate));
                            }
                          },
                          child: const Text("Submit")),
                    )
                  ]),
                ));
          }
          if (state is ReportLoadingState) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }
          if (state is ReportErrorState) {
            return Center(
              child: Column(children: [
                const Text("Something went Wrong"),
                const SizedBox(
                  height: 12,
                ),
                Text(state.message),
                const SizedBox(height: 12),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Try Again"))
              ]),
            );
          }
          return Container();
        },
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vehicle_reporting/bloc/security/security_bloc.dart';
import 'package:vehicle_reporting/security/full_screen_image.dart';
import 'package:vehicle_reporting/security/security_ocr_widget.dart';
import 'package:vehicle_reporting/style.dart';

import '../shared/home/home.dart';
import '../student/image_source_dialog.dart';
import '../utils/cropper.dart';
import '../utils/picker_image.dart';

class Security extends StatefulWidget {
  const Security({super.key});

  @override
  State<Security> createState() => _SecurityState();
}

class _SecurityState extends State<Security> {
  DateFormat dteFormat2 = DateFormat.yMMMMd('en_US').add_jm();
  Timestamp? filterDate;
  @override
  Widget build(BuildContext context) {
    final parentContext = context;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: const Text("Reported Vehicles"),
        actions: [
          IconButton(
              onPressed: () {
                imagePickerModal(
                    context: context,
                    cameraOnTap: () {
                      pickerImage(source: ImageSource.camera).then((value) {
                        if (value.isNotEmpty) {
                          imageCropperView(path: value, context: context)
                              .then((newValue) {
                            if (newValue.isNotEmpty) {
                              parentContext
                                  .read<SecurityBloc>()
                                  .add(ScanVehicle(path: newValue));
                            }
                          });
                        }
                      });
                    },
                    galleryOntap: () {
                      pickerImage(source: ImageSource.gallery).then((value) {
                        if (value.isNotEmpty) {
                          imageCropperView(path: value, context: context)
                              .then((newValue) {
                            if (newValue.isNotEmpty) {
                              parentContext
                                  .read<SecurityBloc>()
                                  .add(ScanVehicle(path: newValue));
                            }
                          });
                        }
                      });
                    });
              },
              icon: const Icon(FontAwesome5.camera)),
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return const HomePage();
                }));
              },
              icon: const Icon(FontAwesome5.sign_out_alt)),
        ],
      ),
      body: BlocConsumer<SecurityBloc, SecurityState>(
        listener: (context, state) {
          BuildContext parent = context;
          if (state is LogPosted) {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Log successfully saved"),
                    content: Column(mainAxisSize: MainAxisSize.min, children: [
                      Text("Owner name: ${state.vehicleLogs.ownerName}"),
                      const SizedBox(
                        height: 8,
                      ),
                      Text("Affiliation: ${state.vehicleLogs.affiliation}"),
                    ]),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            parent
                                .read<SecurityBloc>()
                                .add(GetReportedVehicles());
                          },
                          child: const Text("Ok")),
                    ],
                  );
                });
          }
        },
        builder: (context, state) {
          if (state is ReportedVehiclesLoaded) {
            if (state is SecurityLoadingScreen) {
              return const CircularProgressIndicator(
                color: Colors.black,
              );
            }
            return StreamBuilder<QuerySnapshot>(
                stream: filterDate == null
                    ? FirebaseFirestore.instance
                        .collection("reported_vehicles")
                        .snapshots()
                    : FirebaseFirestore.instance
                        .collection("reported_vehicles")
                        .where('datetime', isLessThanOrEqualTo: filterDate)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return Column(
                    children: [
                      FormBuilderDateTimePicker(
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                filterDate = Timestamp.fromDate(value);
                              });
                            }
                          },
                          decoration: normalTextFieldStyle("Filter", "Filter")
                              .copyWith(
                                  prefixIcon:
                                      const Icon(FontAwesome5.calendar_day)),
                          name: "filter"),
                      Expanded(
                        child: DataTable2(
                            minWidth: 800,
                            columns: const [
                              DataColumn2(label: Text("Plate number")),
                              DataColumn2(label: Text("Affiliation")),
                              DataColumn2(label: Text("Reporter Id")),
                              DataColumn2(label: Text("Date/Time")),
                              DataColumn2(label: Text("Image")),
                              DataColumn2(label: Text("Contact")),
                            ],
                            rows: snapshot.data!.docs.map((e) {
                              var datetime =
                                  (e.get('datetime') as Timestamp).toDate();

                              return DataRow(
                                  onLongPress: () async {
                                    final doc = FirebaseFirestore.instance
                                        .collection('reported_vehicles')
                                        .doc(e.id);
                                    var update = {
                                      'plate_number': e.get('plate_number'),
                                      'owner_affiliation':
                                          e.get('owner_affiliation'),
                                      'student_number': e.get('student_number'),
                                      "datetime": e.get("datetime"),
                                      "image_link": e.get("image_link"),
                                      "owner_contact": e.get("owner_contact"),
                                      "status": !e.get('status'),
                                    };
                                    try {
                                      await doc.update(update);
                                      setState(() {});
                                    } catch (e) {
                                      throw e.toString();
                                    }
                                  },
                                  selected: e.get('status'),
                                  cells: [
                                    DataCell(Text(e.get('plate_number'))),
                                    DataCell(Text(e.get('owner_affiliation'))),
                                    DataCell(Text(e.get('student_number'))),
                                    DataCell(GestureDetector(
                                        child:
                                            Text(dteFormat2.format(datetime)))),
                                    DataCell(GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) {
                                                    return FullScreenImage(
                                                        imageLink: e
                                                            .get('image_link'));
                                                  },
                                                  fullscreenDialog: true));
                                        },
                                        child: Image.network(
                                          e.get('image_link'),
                                          filterQuality: FilterQuality.low,
                                        ))),
                                    DataCell(TextButton(
                                      child: const Text(
                                        "call owner",
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                      onPressed: () {
                                        _makePhoneCall(e.get('owner_contact'));
                                      },
                                    )),
                                  ]);
                            }).toList()),
                      ),
                    ],
                  );
                });
          }
          return Container();
        },
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
}

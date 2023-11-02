import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vehicle_reporting/bloc/admin/admin_bloc.dart';
import 'package:vehicle_reporting/bloc/vehicles/vehicles_bloc.dart';
import 'package:vehicle_reporting/model/vehicle.dart';
import 'package:vehicle_reporting/security/full_screen_image.dart';

import '../shared/home/home.dart';
import '../style.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  DateFormat dteFormat2 = DateFormat.yMMMMd('en_US').add_jm();
  Timestamp? filterDate;
  String? affilation;
  String remarks = "";
  int index = 0;
  bool? status;
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        drawer: Drawer(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              width: double.maxFinite,
              child: DrawerHeader(
                  decoration: BoxDecoration(color: Colors.black),
                  child: Center(
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Text("A"),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text("Administrator")
                      ],
                    ),
                  )),
            ),
            ListTile(
              leading: const Icon(FontAwesome5.car),
              title: const Text("View Vehicles"),
              onTap: () {
                scaffoldKey.currentState!.closeDrawer();
                context.read<AdminBloc>().add(ViewRegisteredVehicle());
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(FontAwesome5.user),
              title: const Text("View Logs"),
              onTap: () {
                scaffoldKey.currentState!.closeDrawer();
                context.read<AdminBloc>().add(LoadLogs());
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(FontAwesome.ioxhost),
              title: const Text("Add Vehicle Owner"),
              onTap: () {
                scaffoldKey.currentState!.closeDrawer();
                context.read<AdminBloc>().add(ShowAddUserScreen());
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(FontAwesome5.sign_out_alt),
              title: const Text("Sign Out"),
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return const HomePage();
                }));
                scaffoldKey.currentState!.closeDrawer();
              },
            ),
          ],
        )),
        appBar: AppBar(
          title: const Text("Administrator"),
        ),
        body: BlocConsumer<AdminBloc, AdminState>(
          listener: (context, state) {
            BuildContext parent = context;
            if (state is RegisteredVehicleApprovaLUpdateState) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title:
                          const Text("Vehicle Registration Update Successfull"),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              parent
                                  .read<AdminBloc>()
                                  .add(ViewRegisteredVehicle());
                            },
                            child: const Text("OK"))
                      ],
                    );
                  });
            }
            if (state is OwnderAdded) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Vehicle Added Successfull"),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              parent.read<AdminBloc>().add(LoadLogs());
                            },
                            child: const Text("OK"))
                      ],
                    );
                  });
            }
          },
          builder: (context, state) {
            if (state is RegisteredVehicleViewingState) {
              index = 0;
              return Column(
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    "All Vehicles",
                    style: TextStyle(fontSize: 16),
                  ),
                  Expanded(
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("registered_vehicle")
                            .snapshots(),
                        builder: ((context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (!snapshot.hasData) {
                            return const Center(
                              child: Text("No Registered Vehicle"),
                            );
                          }

                          return DataTable2(
                              columnSpacing: 8,
                              minWidth: 900,
                              columns: const [
                                DataColumn2(
                                  fixedWidth: 50,
                                  label: Text("No."),
                                ),
                                DataColumn2(
                                  fixedWidth: 120,
                                  label: Text("Plate Number"),
                                ),
                                DataColumn2(
                                    fixedWidth: 120, label: Text("Owner name")),
                                DataColumn2(
                                    fixedWidth: 120,
                                    label: Text("Owner Contact")),
                                DataColumn2(
                                    fixedWidth: 120,
                                    label: Text("Approval Status")),
                                DataColumn2(
                                    fixedWidth: 120, label: Text("Remarks")),
                                DataColumn2(
                                    fixedWidth: 60, label: Text("details"))
                              ],
                              rows: snapshot.data!.docs.map((e) {
                                index++;
                                return DataRow(cells: [
                                  DataCell(
                                    Text(index.toString()),
                                  ),
                                  DataCell(
                                    Text(e.get('plate')),
                                  ),
                                  DataCell(
                                    Text(e.get('owner_name')),
                                  ),
                                  DataCell(
                                    InkWell(
                                        onTap: () {
                                          _makePhoneCall(
                                              e.get('owner_contact'));
                                        },
                                        child: const Text(
                                          "Call Owner",
                                          style: TextStyle(color: Colors.blue),
                                        )),
                                  ),
                                  DataCell(
                                    Text(
                                      e.get('status')
                                          ? "Approved"
                                          : "Not Approve",
                                      style: TextStyle(
                                          color: e.get('status')
                                              ? Colors.green
                                              : Colors.red),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      e.get('remarks') == ""
                                          ? "ongoing review"
                                          : e.get('remarks'),
                                      style: TextStyle(
                                          color: e.get('status')
                                              ? Colors.green
                                              : Colors.red),
                                    ),
                                  ),
                                  DataCell(
                                    InkWell(
                                      onTap: () {
                                        List<String> images = [];
                                        final files = e.get('images');
                                        for (var img in files) {
                                          images.add(img);
                                        }
                                        Vehicle vehicle = Vehicle(
                                            ownerAddress:
                                                e.get("owner_address"),
                                            ownerContact:
                                                e.get("owner_contact"),
                                            ownerName: e.get("owner_name"),
                                            ownerId: e.get("owner_id"),
                                            applyingFor: e.get("applying_for"),
                                            images: images,
                                            brand: e.get("brand"),
                                            color: e.get("color"),
                                            plate: e.get("plate"),
                                            relationship: e.get("relationship"),
                                            remarks: e.get("remarks"),
                                            status: e.get("status"),
                                            type: e.get("vehicle_type"));
                                        context.read<AdminBloc>().add(
                                            ViewRegisteredVehicleDetaiils(
                                                vehicle: vehicle));
                                      },
                                      child: const Text(
                                        "View",
                                        style:
                                            TextStyle(color: Colors.blueAccent),
                                      ),
                                    ),
                                  ),
                                ]);
                              }).toList());
                        })),
                  ),
                ],
              );
            }
            if (state is AdminRegisteredVehicleViewingState) {
              return Column(
                children: [
                  const SizedBox(
                    height: 12,
                  ),
                  const Text(
                    "Vehicle Detailed View",
                    style: TextStyle(fontSize: 16),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        height: 1000,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 42, vertical: 32),
                        child: FormBuilder(
                            child: Column(
                          children: [
                            FormBuilderTextField(
                                enabled: false,
                                initialValue: state.vehicle.ownerName,
                                decoration:
                                    normalTextFieldStyle("Fullname", "Fullname")
                                        .copyWith(
                                  fillColor: Colors.grey,
                                ),
                                name: "fullname"),
                            const SizedBox(
                              height: 12,
                            ),
                            FormBuilderTextField(
                                enabled: false,
                                initialValue: state.vehicle.ownerId,
                                decoration: normalTextFieldStyle("ID", "ID"),
                                name: "id"),
                            const SizedBox(
                              height: 12,
                            ),
                            FormBuilderTextField(
                                enabled: false,
                                initialValue: state.vehicle.ownerAddress,
                                decoration:
                                    normalTextFieldStyle("address", "address"),
                                name: "address"),
                            const SizedBox(
                              height: 12,
                            ),
                            FormBuilderTextField(
                                enabled: false,
                                initialValue: state.vehicle.ownerContact,
                                decoration: normalTextFieldStyle(
                                    "Contact number", "Contact nUmber"),
                                name: "contact"),
                            const SizedBox(
                              height: 12,
                            ),
                            FormBuilderTextField(
                                enabled: false,
                                initialValue: state.vehicle.applyingFor,
                                decoration: normalTextFieldStyle(
                                    "Contact number", "Contact nUmber"),
                                name: "contact"),
                            const SizedBox(
                              height: 12,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: Row(children: [
                                Flexible(
                                  child: FormBuilderTextField(
                                      enabled: false,
                                      initialValue: state.vehicle.type,
                                      decoration: normalTextFieldStyle(
                                          "Vehicle type", "Vehicle type"),
                                      name: "vehicle_type"),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Flexible(
                                  child: FormBuilderTextField(
                                      enabled: false,
                                      initialValue: state.vehicle.brand,
                                      decoration: normalTextFieldStyle(
                                          "Make/Brand", "Make/Brand"),
                                      name: "brand"),
                                ),
                              ]),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: Row(children: [
                                Flexible(
                                  child: FormBuilderTextField(
                                      enabled: false,
                                      initialValue: state.vehicle.color,
                                      decoration: normalTextFieldStyle(
                                          "Color", "Color"),
                                      name: "color"),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Flexible(
                                  child: FormBuilderTextField(
                                      enabled: false,
                                      initialValue: state.vehicle.plate,
                                      decoration: normalTextFieldStyle(
                                          "Plate number", "Plate number"),
                                      name: "plate"),
                                ),
                              ]),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            const Text(
                                "If the vehicle is not registered under your name, please state relationship to registered name"),
                            const SizedBox(
                              height: 5,
                            ),
                            FormBuilderTextField(
                                enabled: false,
                                initialValue: state.vehicle.relationship,
                                decoration: normalTextFieldStyle(
                                    "relationship", "relationship"),
                                name: "relationship"),
                            const SizedBox(
                              height: 12,
                            ),
                            const Text(
                              "[Please Attached photocopy of the latest Motor Vehicles Registration papers OR/CR, 2x2 Picture and Driver License]",
                              style: TextStyle(color: Colors.redAccent),
                            ),
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GridView.builder(
                                  itemCount: state.vehicle.images.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder:
                                                  (BuildContext context) {
                                            return FullScreenImage(
                                                imageLink: state
                                                    .vehicle.images[index]);
                                          }));
                                        },
                                        child: Image.network(
                                          state.vehicle.images[index],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  }),
                            )),
                            const SizedBox(
                              height: 12,
                            ),
                            StatefulBuilder(builder: (context, setState) {
                              return FormBuilderSwitch(
                                  onChanged: (e) {
                                    setState(() {
                                      status = e!;
                                    });
                                  },
                                  initialValue: state.vehicle.status,
                                  decoration: normalTextFieldStyle("", ""),
                                  name: "approved",
                                  title: const Text("Approved Registration"));
                            }),
                            const SizedBox(
                              height: 12,
                            ),
                            FormBuilderTextField(
                                initialValue: state.vehicle.remarks,
                                onChanged: (e) {
                                  setState(() {
                                    remarks = e!;
                                  });
                                },
                                maxLines: 4,
                                decoration:
                                    normalTextFieldStyle("remarks", "remarks"),
                                name: "remarks"),
                            const SizedBox(
                              height: 12,
                            ),
                            SizedBox(
                              width: 300,
                              height: 60,
                              child: ElevatedButton(
                                  style: mainBtnStyle(Colors.teal,
                                      Colors.transparent, Colors.white),
                                  onPressed: () {
                                    final String applyingFor =
                                        state.vehicle.applyingFor;
                                    final String name = state.vehicle.ownerName;
                                    final String id = state.vehicle.ownerId;
                                    final String address =
                                        state.vehicle.ownerAddress;
                                    final String contact =
                                        state.vehicle.ownerContact;
                                    final String type = state.vehicle.type;
                                    final String brand = state.vehicle.brand;
                                    final String color = state.vehicle.color;
                                    final String plate = state.vehicle.plate;
                                    final String relationship =
                                        state.vehicle.relationship;
                                    Vehicle vehicle = Vehicle(
                                        ownerAddress: address,
                                        ownerContact: contact,
                                        ownerName: name,
                                        ownerId: id,
                                        applyingFor: applyingFor,
                                        images: state.vehicle.images,
                                        brand: brand,
                                        color: color,
                                        plate: plate,
                                        relationship: relationship,
                                        remarks: remarks.isEmpty
                                            ? state.vehicle.remarks
                                            : remarks,
                                        status: status ??= state.vehicle.status,
                                        type: type);
                                    print(status);
                                    context.read<AdminBloc>().add(
                                        UpdateRegisterVehicleApproval(
                                            vehicle: vehicle));
                                    setState(() {});
                                  },
                                  child: const Text("Update Approval")),
                            )
                          ],
                        )),
                      ),
                    ),
                  ),
                ],
              );
            }

            if (state is LogsLoaded) {
              return StreamBuilder<QuerySnapshot>(
                  stream: filterDate == null
                      ? FirebaseFirestore.instance
                          .collection("vehicle_logs")
                          .snapshots()
                      : FirebaseFirestore.instance
                          .collection("vehicle_logs")
                          .where('datetime', isLessThanOrEqualTo: filterDate)
                          .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Vehicle Logs",
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(fontSize: 24),
                          ),
                        ),
                        FormBuilderDateTimePicker(
                            decoration: normalTextFieldStyle("Filter", "Filter")
                                .copyWith(
                                    prefixIcon:
                                        const Icon(FontAwesome5.calendar_day)),
                            name: "filter",
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  filterDate = Timestamp.fromDate(value);
                                });
                              }
                            }),
                        Expanded(
                          child: DataTable2(
                              minWidth: 600,
                              columns: const [
                                DataColumn2(
                                    fixedWidth: 100,
                                    label: Text("Plate number")),
                                DataColumn2(label: Text("Owner name")),
                                DataColumn2(label: Text("Affiliation")),
                                DataColumn2(label: Text("Date Time")),
                              ],
                              rows: snapshot.data!.docs.map((e) {
                                var datetime =
                                    (e.get('datetime') as Timestamp).toDate();
                                return DataRow(cells: [
                                  DataCell(Text(e.get('plate_number'))),
                                  DataCell(Text(e.get('owner_name'))),
                                  DataCell(Text(e.get('affiliation'))),
                                  DataCell(Text(dteFormat2.format(datetime)))
                                ]);
                              }).toList()),
                        ),
                      ],
                    );
                  });
            }
            if (state is AddUserFormLoaded) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Add Vehicle Owner",
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall!
                          .copyWith(fontSize: 24),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 32, horizontal: 28),
                    child: Center(
                        child: FormBuilder(
                      key: formKey,
                      child: Column(children: [
                        FormBuilderTextField(
                          textCapitalization: TextCapitalization.characters,
                          decoration: normalTextFieldStyle(
                              "Plate Number", "Plate Number"),
                          name: "plate",
                          validator: (value) {
                            if (value == null) {
                              return "This field is required";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        FormBuilderTextField(
                          decoration:
                              normalTextFieldStyle("Owner Name", "Owner Name"),
                          name: "name",
                          validator: (value) {
                            if (value == null) {
                              return "This field is required";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        FormBuilderTextField(
                          keyboardType: TextInputType.number,
                          decoration: normalTextFieldStyle(
                              "Contact Number", "Contact Number"),
                          name: "contact",
                          validator: (value) {
                            if (value == null) {
                              return "This field is required";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        FormBuilderDropdown(
                          validator: (value) {
                            if (value == null) {
                              return "This field is required";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            affilation = value;
                          },
                          decoration: normalTextFieldStyle(
                              "Affiliation", "Affiliation"),
                          name: "affiliation",
                          items: ["Employee", "Student"]
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        SizedBox(
                          width: 300,
                          height: 50,
                          child: ElevatedButton(
                              style: mainBtnStyle(Colors.black,
                                  Colors.transparent, Colors.white10),
                              onPressed: () {
                                if (formKey.currentState!.saveAndValidate()) {
                                  String plate = formKey
                                      .currentState!.value['plate']
                                      .toString()
                                      .toUpperCase();
                                  String name =
                                      formKey.currentState!.value['name'];
                                  String contact =
                                      formKey.currentState!.value['contact'];
                                  String affiliation = affilation!;
                                  context.read<AdminBloc>().add(AddUser(
                                      affiliation: affiliation,
                                      contact: contact,
                                      ownerName: name,
                                      plateNumber: plate));
                                }
                              },
                              child: const Text("Submit")),
                        )
                      ]),
                    )),
                  ),
                ],
              );
            }
            if (state is AdminRegisteredVehicleViewingState) {}
            if (state is AdminLoadingState) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }
            if (state is AdminErrorState) {
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
                        context.read<AdminBloc>().add(LoadLogs());
                      },
                      child: const Text("Try Again"))
                ]),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
